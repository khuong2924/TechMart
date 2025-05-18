import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const _key = 'accessToken';

  static Future<void> saveToken(String token) async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_key, token);
    } else {
      const storage = FlutterSecureStorage();
      await storage.write(key: _key, value: token);
    }
  }

  static Future<String?> getToken() async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_key);
    } else {
      const storage = FlutterSecureStorage();
      return await storage.read(key: _key);
    }
  }
} 