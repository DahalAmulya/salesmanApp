import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageResponse {
  final String value;

  SecureStorageResponse({
    required this.value,
  });
}

class SecureStorage {
  static String userEmail = 'userEmail';
  static String password = 'password';
  static String accessToken = 'accessToken';
  static String refreshToken = 'refreshToken';
  static String userId = 'userId';
  static String rememberMe = 'false';

  static FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<void> writeLoginCredentials(String key, String value) async {
    await storage.write(key: key, value: value);
  }

  Future<SecureStorageResponse> readLoginCredentials(String key) async {
    String value = await storage.read(key: key) ?? '';
    return SecureStorageResponse(value: value);
  }

  Future<void> deleteLoginCredentials(String key) async {
    await storage.delete(key: key);
  }
}
