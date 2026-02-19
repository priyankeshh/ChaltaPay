import 'package:flutter/foundation.dart';
import 'package:screen_protector/screen_protector.dart';

class AppSecurity {
  /// Prevent screenshots & screen recording (Android + iOS)
  static Future<void> secureScreen() async {
    if (!kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.android ||
         defaultTargetPlatform == TargetPlatform.iOS)) {
      try {
        await ScreenProtector.preventScreenshotOn();
      } catch (e) {
        debugPrint("Failed to secure screen: $e");
      }
    }
  }

  /// Optional — allow screenshots again
  static Future<void> unsecureScreen() async {
    if (!kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.android ||
         defaultTargetPlatform == TargetPlatform.iOS)) {
      try {
        await ScreenProtector.preventScreenshotOff();
      } catch (e) {
        debugPrint("Failed to unsecure screen: $e");
      }
    }
  }
}
