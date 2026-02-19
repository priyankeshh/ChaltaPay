import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

class UssdService {
  static const MethodChannel _channel = MethodChannel('com.chaltapay/ussd');
  static const EventChannel _eventChannel = EventChannel('com.chaltapay/ussd_events');

  Future<void> dialUssd(String code) async {
    final status = await Permission.phone.status;
    if (!status.isGranted) {
      final result = await Permission.phone.request();
      if (!result.isGranted) {
        throw Exception('Phone permission is required to dial USSD codes.');
      }
    }

    try {
      await _channel.invokeMethod('dial', {'code': code});
    } on PlatformException catch (e) {
      throw Exception('Failed to dial USSD: ${e.message}');
    }
  }

  Future<void> openAccessibilitySettings() async {
    try {
      await _channel.invokeMethod('openAccessibilitySettings');
    } on PlatformException catch (e) {
      throw Exception('Failed to open accessibility settings: ${e.message}');
    }
  }

  Stream<String> get ussdMessages {
    return _eventChannel.receiveBroadcastStream().map((event) => event.toString());
  }
}

final ussdServiceProvider = Provider<UssdService>((ref) {
  return UssdService();
});
