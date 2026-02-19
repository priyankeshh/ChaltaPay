import 'dart:convert';
import 'dart:math';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:crypto/crypto.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageService()
      : _storage = const FlutterSecureStorage(
          aOptions: AndroidOptions(
            encryptedSharedPreferences: true,
          ),
        );

  static const String _dbKey = 'db_encryption_key';

  /// Retrieves the existing database encryption key or generates a new one.
  /// The key is a base64 encoded string representing 32 bytes (256 bits).
  Future<String> getOrCreateDatabaseKey() async {
    String? key = await _storage.read(key: _dbKey);

    if (key == null) {
      key = _generateSecureKey();
      await _storage.write(key: _dbKey, value: key);
    }

    return key;
  }

  /// Generates a cryptographically secure 256-bit random key.
  String _generateSecureKey() {
    final random = Random.secure();
    final values = List<int>.generate(32, (i) => random.nextInt(256));
    return base64Url.encode(values);
  }
}
