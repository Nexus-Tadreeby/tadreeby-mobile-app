import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'dart:io';
import '../constants/api_constants.dart';
import 'auth_interceptor.dart';

class DioClient {
  late final Dio _dio;

  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    (_dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate = 
        (HttpClient client) {
          client.badCertificateCallback = 
            (X509Certificate cert, String host, int port) => true;
          return client;
        };
    
    _dio.interceptors.add(AuthInterceptor());
    
    _dio.interceptors.add(LogInterceptor(
      responseBody: true, 
      requestBody: true,
      requestHeader: true,
      responseHeader: true,
    ));
  }

  Dio get dio => _dio;
}