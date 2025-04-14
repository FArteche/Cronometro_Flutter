package com.example.cronometro

import android.Manifest
import android.content.Intent
import android.os.Build
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import androidx.core.app.NotificationCompat

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.cronometro/background"

    private fun showLapNotification(lapNumber: Int, lapTime: Int) {
        val channelId = "lap_notifications"
        val notificationManager =
                getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

        // Criar canal de notificação para Android 8.0+
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channelName = "Voltas do Cronômetro"
            val channel =
                    NotificationChannel(
                            channelId,
                            channelName,
                            NotificationManager.IMPORTANCE_DEFAULT
                    )
            notificationManager.createNotificationChannel(channel)
        }

        // Formatar o tempo da volta
        val minutes = lapTime / 60
        val seconds = lapTime % 60
        val timeFormatted = String.format("%02d:%02d", minutes, seconds)

        // Criar a notificação
        val notification =
                NotificationCompat.Builder(this, channelId)
                        .setContentTitle("Volta #$lapNumber registrada")
                        .setContentText("Tempo: $timeFormatted")
                        .setSmallIcon(android.R.drawable.ic_dialog_info)
                        .setPriority(NotificationCompat.PRIORITY_DEFAULT)
                        .setAutoCancel(true)
                        .build()

        // Mostrar notificação com ID único baseado no número da volta
        notificationManager.notify(1000 + lapNumber, notification)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Solicitar permissão para notificações em Android 13+
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            requestPermissions(arrayOf(android.Manifest.permission.POST_NOTIFICATIONS), 100)
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call,
                result ->
            when (call.method) {
                "startTimer" -> {
                    val seconds = call.argument<Int>("seconds") ?: 0
                    val intent =
                            Intent(this, TimerService::class.java).apply {
                                action = "START"
                                putExtra("seconds", seconds)
                            }
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        startForegroundService(intent)
                    } else {
                        startService(intent)
                    }
                    result.success(null)
                }
                "stopTimer" -> {
                    val intent = Intent(this, TimerService::class.java).apply { action = "STOP" }
                    startService(intent)
                    result.success(null)
                }
                "resetTimer" -> {
                    val intent = Intent(this, TimerService::class.java).apply { action = "RESET" }
                    startService(intent)
                    result.success(null)
                }
                "getSeconds" -> {
                    result.success(TimerService.currentSeconds)
                }
                "isRunning" -> {
                    result.success(TimerService.currentIsRunning)
                }
                "addLap" -> {
                    val lapNumber = call.argument<Int>("lapNumber") ?: 0
                    val lapTime = call.argument<Int>("lapTime") ?: 0
                    showLapNotification(lapNumber, lapTime)
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }
}
