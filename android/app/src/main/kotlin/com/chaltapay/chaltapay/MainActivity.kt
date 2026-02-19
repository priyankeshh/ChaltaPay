package com.chaltapay.chaltapay

import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.provider.Settings
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach


class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.chaltapay/ussd"
    private val EVENT_CHANNEL = "com.chaltapay/ussd_events"
    private var eventJob: Job? = null

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "dial" -> {
                    val code = call.argument<String>("code")
                    if (code != null) {
                        dialUssd(code, result)
                    } else {
                        result.error("INVALID_ARGUMENT", "USSD code is null", null)
                    }
                }
                "openAccessibilitySettings" -> {
                    openAccessibilitySettings(result)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT_CHANNEL).setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    eventJob = UssdAccessibilityService.ussdEvents
                        .onEach { text ->
                            runOnUiThread {
                                events?.success(text)
                            }
                        }
                        .launchIn(CoroutineScope(Dispatchers.Main))
                }

                override fun onCancel(arguments: Any?) {
                    eventJob?.cancel()
                    eventJob = null
                }
            }
        )
    }

    private fun dialUssd(code: String, result: MethodChannel.Result) {
        if (checkSelfPermission(android.Manifest.permission.CALL_PHONE) != PackageManager.PERMISSION_GRANTED) {
            result.error("PERMISSION_DENIED", "CALL_PHONE permission is missing", null)
            return
        }

        try {
            val encodedCode = Uri.encode(code)
            val intent = Intent(Intent.ACTION_CALL)
            intent.data = Uri.parse("tel:$encodedCode")
            startActivity(intent)
            result.success("Dialing initiated")
        } catch (e: Exception) {
            result.error("DIAL_ERROR", "Failed to dial USSD: ${e.message}", null)
        }
    }

    private fun openAccessibilitySettings(result: MethodChannel.Result) {
        try {
            val intent = Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS)
            startActivity(intent)
            result.success(true)
        } catch (e: Exception) {
            result.error("SETTINGS_ERROR", "Failed to open accessibility settings: ${e.message}", null)
        }
    }
}
