import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  late final FlutterSecureStorage _storage;
  SecureStorage._() {
    AndroidOptions _getAndroidOptions() => const AndroidOptions(
          encryptedSharedPreferences: true,
        );
    _storage = FlutterSecureStorage(aOptions: _getAndroidOptions());
  }

  static SecureStorage instance = SecureStorage._();

  //FlutterSecureStorage get storage => _storage;

  Future<String?> readToken() async {
    try {
      return await _storage.read(key: 'token');
    } catch (e) {
      return null;
    }
  }

  Future<bool> writeToken(String token) async {
    try {
      await _storage.write(key: 'token', value: token);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteToken() async {
    try {
      await _storage.delete(key: 'token');
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, String>> readAll() async {
    return await _storage.readAll();
  }
}
