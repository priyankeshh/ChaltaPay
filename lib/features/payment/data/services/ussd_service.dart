import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UssdService {
  static const MethodChannel _channel = MethodChannel('com.chaltapay/ussd');
  static const EventChannel _eventChannel = EventChannel('com.chaltapay/ussd_events');

  Future<void> dialUssd(String code) async {
    try {
      await _channel.invokeMethod('dial', {'code': code});
    } on PlatformException catch (e) {
      throw Exception('Failed to dial USSD: ${e.message}');
    }
  }

  Stream<String> get ussdMessages {
    return _eventChannel.receiveBroadcastStream().map((event) => event.toString());
  }
}

final ussdServiceProvider = Provider<UssdService>((ref) {
  return UssdService();
});
