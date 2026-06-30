import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import '../utils/secure_storage_service.dart';

class AuthInterceptor extends Interceptor {
  final SecureStorageService _storageService = SecureStorageService();
  final Dio _dio = Dio(); 

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final accessToken = await _storageService.getAccessToken();

    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    return handler.next(options);
  }



  @override
Future<void> onError(
  DioException err,
  ErrorInterceptorHandler handler,
) async {
  if (err.response?.statusCode == 401) {
    final refreshToken = await _storageService.getRefreshToken();

    if (refreshToken != null) {
      try {
        final response = await _dio.post(
          ApiConstants.refresh,
          data: {'refreshToken': refreshToken},
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          final newAccessToken = response.data['accessToken'];
          final newRefreshToken = response.data['refreshToken'];

          await _storageService.saveAccessToken(newAccessToken);
          if (newRefreshToken != null) {
            await _storageService.saveRefreshToken(newRefreshToken);
          }

          final requestOptions = err.requestOptions;
          requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';

          final cloneReq = await _dio.request(
            requestOptions.path,
            options: Options(
              method: requestOptions.method,
              headers: requestOptions.headers,
            ),
            data: requestOptions.data,
            queryParameters: requestOptions.queryParameters,
          );

          return handler.resolve(cloneReq);
        }
      } catch (e) {
        await _storageService.clearAuthData();
      }
    }
  }

  return handler.next(err);
}
}