// lib/core/utils/secure_storage_service.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _tokenExpiryKey = 'token_expiry';
  static const String _hasSeenOnboardingKey = 'has_seen_onboarding';

  // ─── Access Token ──────────────────────────────────────────
  Future<void> saveAccessToken(String token) async {
    await _storage.write(key: _accessTokenKey, value: token);
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  // ─── Refresh Token ──────────────────────────────────────────
  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _refreshTokenKey, value: token);
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  // ─── Token Expiry (وقت انتهاء الصلاحية) ──────────────────────
  Future<void> saveTokenExpiry(DateTime expiry) async {
    final expiryStr = expiry.toIso8601String();
    await _storage.write(key: _tokenExpiryKey, value: expiryStr);
  }

  Future<DateTime?> getTokenExpiry() async {
    final expiryStr = await _storage.read(key: _tokenExpiryKey);
    if (expiryStr != null) {
      try {
        return DateTime.parse(expiryStr);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  // ✅ التحقق من انتهاء الصلاحية
  Future<bool> isTokenExpired() async {
    final expiry = await getTokenExpiry();
    if (expiry == null) return true;
    // ✅ ترك 30 ثانية هامش أمان
    return DateTime.now().isAfter(expiry.subtract(const Duration(seconds: 30)));
  }

  // ─── Clear Data ─────────────────────────────────────────────
  Future<void> clearAuthData() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    await _storage.delete(key: _tokenExpiryKey); // ✅ حذف وقت انتهاء الصلاحية
    print('🗑️ Auth data cleared');
  }

  // ─── Onboarding ─────────────────────────────────────────────
  Future<bool> hasSeenOnboarding() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_hasSeenOnboardingKey) ?? false;
    } catch (e) {
      return false;
    }
  }

  Future<void> setHasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hasSeenOnboardingKey, true);
  }

  Future<void> resetOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_hasSeenOnboardingKey);
  }

  // ─── Debug ──────────────────────────────────────────────────
  Future<void> printAllData() async {
    final all = await _storage.readAll();
    print('📦 All Secure Storage Data: $all');
  }

  Future<void> resetAllData() async {
    await _storage.deleteAll();
    print('🗑️ All secure storage data deleted!');
  }
}
