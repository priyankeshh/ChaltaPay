package com.chaltapay.chaltapay

import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.chaltapay/ussd"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "dial") {
                val code = call.argument<String>("code")
                if (code != null) {
                    dialUssd(code, result)
                } else {
                    result.error("INVALID_ARGUMENT", "USSD code is null", null)
                }
            } else {
                result.notImplemented()
            }
        }
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
}
