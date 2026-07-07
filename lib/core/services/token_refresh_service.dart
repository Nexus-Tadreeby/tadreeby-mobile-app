import 'dart:async';
import '../network/auth_interceptor.dart';
import '../utils/secure_storage_service.dart';

class TokenRefreshService {
  static final TokenRefreshService _instance = TokenRefreshService._internal();
  factory TokenRefreshService() => _instance;
  TokenRefreshService._internal();

  final SecureStorageService _storageService = SecureStorageService();
  Timer? _refreshTimer;
  bool _isRefreshing = false;

  void startAutoRefresh() {
    print('🔄 Starting auto-refresh service...');

    _refreshTimer?.cancel();

    _refreshTimer = Timer.periodic(
      const Duration(minutes: 14),
      (timer) async {
        await _refreshTokenIfNeeded();
      },
    );
  }

  void stopAutoRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
    print('🛑 Auto-refresh service stopped');
  }

  Future<void> _refreshTokenIfNeeded() async {
    if (_isRefreshing) return;

    try {
      final token = await _storageService.getAccessToken();
      if (token == null) {
        print('⚠️ No token found, skipping refresh');
        return;
      }

      _isRefreshing = true;
      print('🔄 Auto-refreshing token...');

      final interceptor = AuthInterceptor();
      final newToken = await interceptor.refreshToken();

      if (newToken != null) {
        print('✅ Auto-refresh successful at ${DateTime.now()}');
      } else {
        print('❌ Auto-refresh failed - token might be invalid');
      }
    } catch (e) {
      print('❌ Auto-refresh error: $e');
    } finally {
      _isRefreshing = false;
    }
  }

  Future<void> refreshImmediately() async {
    if (_isRefreshing) return;
    await _refreshTokenIfNeeded();
  }

  void dispose() {
    stopAutoRefresh();
  }
}