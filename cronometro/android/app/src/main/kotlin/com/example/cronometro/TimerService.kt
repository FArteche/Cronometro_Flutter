package com.example.cronometro

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import androidx.core.app.NotificationCompat

class TimerService : Service() {
    private var seconds = 0
    private var isRunning = false
    private val handler = Handler(Looper.getMainLooper())
    private lateinit var runnable: Runnable
    private lateinit var notificationManager: NotificationManager

    companion object {
        var currentSeconds = 0
        var currentIsRunning = false
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    override fun onCreate() {
        super.onCreate()
        notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        when (intent?.action) {
            "START" -> {
                seconds = intent.getIntExtra("seconds", 0)
                startTimer()
            }
            "STOP" -> stopTimer()
            "RESET" -> resetTimer()
        }
        return START_STICKY
    }

    private fun startTimer() {
        if (!isRunning) {
            isRunning = true
            currentIsRunning = true
            startForegroundService()
            runnable = object : Runnable {
                override fun run() {
                    if (isRunning) {
                        seconds++
                        currentSeconds = seconds
                        updateNotification() // Atualiza a notificação a cada segundo
                        handler.postDelayed(this, 1000)
                    }
                }
            }
            handler.post(runnable)
        }
    }

    private fun stopTimer() {
        isRunning = false
        currentIsRunning = false
        handler.removeCallbacks(runnable)
        updateNotification() // Mostra o tempo pausado
        stopForeground(false) // Mantém a notificação, mas remove o status de "foreground"
    }

    private fun resetTimer() {
        stopTimer()
        seconds = 0
        currentSeconds = 0
        updateNotification() // Atualiza para 00:00
    }

    private fun startForegroundService() {
        val channelId = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            createNotificationChannel()
        } else {
            ""
        }

        val notification = buildNotification()
        startForeground(1, notification)
    }

    private fun updateNotification() {
        val notification = buildNotification()
        notificationManager.notify(1, notification) // Atualiza a notificação existente
    }

    private fun buildNotification(): Notification {
        val minutes = seconds / 60
        val remainingSeconds = seconds % 60
        val timeText = String.format("%02d:%02d", minutes, remainingSeconds)

        return NotificationCompat.Builder(this, "timer_service")
            .setContentTitle("Cronômetro")
            .setContentText("Tempo: $timeText")
            .setSmallIcon(android.R.drawable.ic_media_play)
            .setOngoing(isRunning) // Mantém a notificação fixa enquanto rodando
            .setPriority(NotificationCompat.PRIORITY_LOW) // Evita interrupções
            .setSilent(true) // Sem som ou vibração
            .build()
    }

    private fun createNotificationChannel(): String {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channelId = "timer_service"
            val channelName = "Timer Service"
            val channel = NotificationChannel(channelId, channelName, NotificationManager.IMPORTANCE_LOW)
            channel.setSound(null, null) // Silencioso
            notificationManager.createNotificationChannel(channel)
            return channelId
        }
        return ""
    }

    override fun onDestroy() {
        super.onDestroy()
        handler.removeCallbacks(runnable)
    }
}