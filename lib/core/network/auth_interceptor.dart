// lib/core/network/auth_interceptor.dart
import 'dart:convert';
import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import '../utils/secure_storage_service.dart';

class AuthInterceptor extends Interceptor {
  final SecureStorageService _storageService = SecureStorageService();
  late final Dio _dio;
  bool _isRefreshing = false;
  final List<RequestOptions> _failedRequests = [];

  AuthInterceptor() {
    _dio = Dio(BaseOptions(
      validateStatus: (status) => status != null && status < 500,
    ));
  }

  Future<String?> refreshToken() async {
    return await _refreshToken();
  }

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.path == ApiConstants.refresh) {
      return handler.next(options);
    }

    final accessToken = await _storageService.getAccessToken();

    if (accessToken != null) {
      if (_isTokenExpired(accessToken)) {
        print('⏰ Token expired - trying to refresh...');
        final newToken = await _refreshToken();
        if (newToken != null) {
          options.headers['Authorization'] = 'Bearer $newToken';
          print('✅ Token refreshed before request');
          return handler.next(options);
        } else {
          print('❌ Failed to refresh token');
          await _storageService.clearAuthData();
          return handler.reject(DioException(
            requestOptions: options,
            error: 'Token expired and refresh failed',
            type: DioExceptionType.badResponse,
          ));
        }
      } else {
        options.headers['Authorization'] = 'Bearer $accessToken';
        print('🔑 Token added to request: ${accessToken.substring(0, 20)}...');
      }
    } else {
      print('⚠️ No access token found');
    }

    return handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      print('🔐 401 Unauthorized - Attempting to refresh token...');

      if (err.requestOptions.path == ApiConstants.refresh) {
        print('❌ Refresh token failed, clearing auth data');
        await _storageService.clearAuthData();
        return handler.reject(err);
      }

      if (_isRefreshing) {
        _failedRequests.add(err.requestOptions);
        return handler.reject(err);
      }

      _isRefreshing = true;

      try {
        final newToken = await _refreshToken();

        if (newToken != null) {
          print('✅ Token refreshed successfully');

          final requestOptions = err.requestOptions;
          requestOptions.headers['Authorization'] = 'Bearer $newToken';

          final cloneReq = await _dio.request(
            requestOptions.path,
            options: Options(
              method: requestOptions.method,
              headers: requestOptions.headers,
            ),
            data: requestOptions.data,
            queryParameters: requestOptions.queryParameters,
          );

          for (final request in _failedRequests) {
            try {
              await _dio.request(
                request.path,
                options: Options(
                  method: request.method,
                  headers: {
                    ...request.headers,
                    'Authorization': 'Bearer $newToken',
                  },
                ),
                data: request.data,
                queryParameters: request.queryParameters,
              );
            } catch (e) {
              print('❌ Failed to retry request: $e');
            }
          }
          _failedRequests.clear();

          return handler.resolve(cloneReq);
        } else {
          print('❌ Failed to refresh token');
          await _storageService.clearAuthData();
          return handler.reject(err);
        }
      } catch (e) {
        print('❌ Error refreshing token: $e');
        await _storageService.clearAuthData();
        return handler.reject(err);
      } finally {
        _isRefreshing = false;
      }
    }

    return handler.next(err);
  }

  // ─── Helper Methods ──────────────────────────────────────

  bool _isTokenExpired(String token) {
    try {
      final payload = _decodeTokenPayload(token);
      if (payload.containsKey('exp')) {
        final exp = payload['exp'] as int;
        final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
        return exp < now + 30;
      }
      return true;
    } catch (e) {
      return true;
    }
  }

  Map<String, dynamic> _decodeTokenPayload(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return {};

      final normalized = base64Url.normalize(parts[1]);
      final decoded = base64Url.decode(normalized);
      final jsonString = utf8.decode(decoded);
      return json.decode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      return {};
    }
  }

  Future<String?> _refreshToken() async {
    try {
      final refreshToken = await _storageService.getRefreshToken();
      if (refreshToken == null) {
        print('❌ No refresh token available');
        return null;
      }

      print('🔄 Sending refresh request...');

      final response = await _dio.post(
        ApiConstants.refresh,
        data: {'refreshToken': refreshToken},
        options: Options(
          headers: {'Content-Type': 'application/json'},
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      print('🔄 Refresh response status: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        final newAccessToken = data['accessToken'] as String?;
        final newRefreshToken = data['refreshToken'] as String?;

        if (newAccessToken != null) {
          await _storageService.saveAccessToken(newAccessToken);
          if (newRefreshToken != null) {
            await _storageService.saveRefreshToken(newRefreshToken);
          }
          print('✅ New tokens saved');
          return newAccessToken;
        } else {
          print('❌ No access token in response');
          return null;
        }
      } else {
        print('❌ Refresh failed with status: ${response.statusCode}');
        print('❌ Response: ${response.data}');
        return null;
      }
    } catch (e) {
      print('❌ Refresh error: $e');
      return null;
    }
  }

   
}