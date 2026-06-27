import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../models/login_response_model.dart';
import '../models/register_request_model.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponseModel> login(String email, String password);
  Future<LoginResponseModel> registerStudent(RegisterRequestModel requestModel);
  Future<void> logout(String refreshToken);
  
  Future<String> forgotPassword(String email);
  Future<String> verifyResetCode(String email, String code);
  Future<bool> resetPassword(String resetToken, String newPassword);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSourceImpl(DioClient dioClient) : _dio = dioClient.dio;

  @override
  Future<LoginResponseModel> login(String email, String password) async {
    try {
      final response = await _dio.post(ApiConstants.login, data: {'email': email, 'password': password});
      return LoginResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'An error occurred while logging in.');
    }
  }

  @override
  Future<LoginResponseModel> registerStudent(RegisterRequestModel requestModel) async {
    try {
      final formData = await requestModel.toFormData();
      final response = await _dio.post(
        ApiConstants.registerStudent,
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );
      return LoginResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'An error occurred while creating the account.');
    }
  }

  @override
  Future<void> logout(String refreshToken) async {
    try {
      await _dio.post(ApiConstants.logout, data: {'refreshToken': refreshToken});
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'An error occurred while logging out.');
    }
  }

  @override
  Future<String> forgotPassword(String email) async {
    try {
      final response = await _dio.post(ApiConstants.forgotPassword, data: {'email': email});
      return response.data['message'] ?? 'An error occurred while sending the verification code.';
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to send verification code.');
    }
  }

  @override
  Future<String> verifyResetCode(String email, String code) async {
    try {
      final response = await _dio.post(ApiConstants.verifyResetCode, data: {'email': email, 'code': code});
      return response.data['resetToken'] ?? '';
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'The entered code is incorrect.');
    }
  }

  @override
  Future<bool> resetPassword(String resetToken, String newPassword) async {
    try {
      final response = await _dio.post(
        ApiConstants.resetPassword,
        data: {
          'resetToken': resetToken,
          'newPassword': newPassword,
        },
      );
      return response.data['success'] ?? true;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to reset password');
    }
  }
}