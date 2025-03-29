package com.example.cronometro

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.Intent

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.cronometro/background"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "startTimer" -> {
                    val seconds = call.argument<Int>("seconds") ?: 0
                    val intent = Intent(this, TimerService::class.java).apply {
                        action = "START"
                        putExtra("seconds", seconds)
                    }
                    startService(intent)
                    result.success(null)
                }
                "stopTimer" -> {
                    val intent = Intent(this, TimerService::class.java).apply {
                        action = "STOP"
                    }
                    startService(intent)
                    result.success(null)
                }
                "resetTimer" -> {
                    val intent = Intent(this, TimerService::class.java).apply {
                        action = "RESET"
                    }
                    startService(intent)
                    result.success(null)
                }
                "getSeconds" -> result.success(TimerService.currentSeconds)
                "isRunning" -> result.success(TimerService.currentIsRunning)
                else -> result.notImplemented()
            }
        }
    }
}