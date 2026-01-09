package com.wheelseye.debug_hub.debug_hub

import android.app.ActivityManager
import android.content.Context
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.debughub.memory_monitor/device_memory"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getDeviceMemory") {
                try {
                    val memoryInfo = getDeviceMemoryInfo()
                    result.success(memoryInfo)
                } catch (e: Exception) {
                    result.error("ERROR", "Failed to get device memory: ${e.message}", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun getDeviceMemoryInfo(): Map<String, Any> {
        val activityManager = getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        val memInfo = ActivityManager.MemoryInfo()
        activityManager.getMemoryInfo(memInfo)

        // Total device RAM
        val totalRAM = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN) {
            memInfo.totalMem / (1024 * 1024) // Convert to MB
        } else {
            // Fallback for older Android versions
            Runtime.getRuntime().maxMemory() / (1024 * 1024)
        }

        // Available RAM
        val availableRAM = memInfo.availMem / (1024 * 1024) // Convert to MB

        // Used RAM
        val usedRAM = totalRAM - availableRAM

        // Usage percentage
        val usagePercentage = if (totalRAM > 0) {
            (usedRAM.toDouble() / totalRAM.toDouble()) * 100.0
        } else {
            0.0
        }

        return mapOf(
            "totalRAMMB" to totalRAM.toInt(),
            "availableRAMMB" to availableRAM.toInt(),
            "usedRAMMB" to usedRAM.toInt(),
            "usagePercentage" to usagePercentage
        )
    }
}
