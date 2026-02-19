import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:flutter/foundation.dart';

class AppSecurity {
  /// Enables FLAG_SECURE on Android to prevent screenshots and screen recording.
  /// This is crucial for fintech apps to protect sensitive data.
  static Future<void> secureScreen() async {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      try {
        await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
      } catch (e) {
        debugPrint("Failed to secure screen: $e");
      }
    }
  }
}
