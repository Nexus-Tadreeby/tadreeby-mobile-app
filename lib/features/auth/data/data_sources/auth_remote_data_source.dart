import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../models/login_response_model.dart';
import '../models/register_request_model.dart';
import '../models/forgot_password_request_model.dart';
import '../models/verify_reset_code_request_model.dart';
import '../models/reset_password_request_model.dart';
import '../models/forgot_password_response_model.dart';
import '../models/verify_reset_code_response_model.dart';
import '../models/reset_password_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponseModel> login(String email, String password);
  Future<LoginResponseModel> registerStudent(RegisterRequestModel requestModel);
  Future<void> logout(String refreshToken);
  
  Future<ForgotPasswordResponseModel> forgotPassword(ForgotPasswordRequestModel request);
  Future<VerifyResetCodeResponseModel> verifyResetCode(VerifyResetCodeRequestModel request);
  Future<ResetPasswordResponseModel> resetPassword(ResetPasswordRequestModel request);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSourceImpl(DioClient dioClient) : _dio = dioClient.dio;

  @override
  Future<LoginResponseModel> login(String email, String password) async {
    try {
      print('📤 Sending login request to: ${ApiConstants.login}');
      print('📤 Email: $email');
      print('📤 Password: ${'*' * password.length}');
      
      final response = await _dio.post(
        ApiConstants.login, 
        data: {'email': email, 'password': password}
      );
      
      print('📥 Response status: ${response.statusCode}');
      print('📥 Response data: ${response.data}');
      
      return LoginResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      print('❌ Dio Error: ${e.response?.statusCode}');
      print('❌ Response data: ${e.response?.data}');
      print('❌ Error message: ${e.message}');
      
      throw Exception(e.response?.data['message'] ?? 'An error occurred while logging in.');
    }
  }

  // @override
  // Future<LoginResponseModel> registerStudent(RegisterRequestModel requestModel) async {
  //   try {
  //     final formData = await requestModel.toFormData();
  //     final response = await _dio.post(
  //       ApiConstants.registerStudent,
  //       data: formData,
  //       options: Options(headers: {'Content-Type': 'multipart/form-data'}),
  //     );
  //     return LoginResponseModel.fromJson(response.data);
  //   } on DioException catch (e) {
  //     throw Exception(e.response?.data['message'] ?? 'An error occurred while creating the account.');
  //   }
  // }



@override
Future<LoginResponseModel> registerStudent(RegisterRequestModel requestModel) async {
  try {
    final file = File(requestModel.verificationDocumentPath);
    final bytes = await file.readAsBytes();
    final base64File = base64Encode(bytes);
    
    final data = {
      'firstName': requestModel.firstName,
      'lastName': requestModel.lastName,
      'personalID': requestModel.personalID,
      'studentNumber': requestModel.studentNumber,
      'phone': requestModel.phone,
      'email': requestModel.email,
      'password': requestModel.password,
      'confirmPassword': requestModel.confirmPassword,
      'universityId': requestModel.universityId,
      'major': requestModel.major,
      'verificationDocument': base64File,
    };
    
    
    final response = await _dio.post(
      ApiConstants.registerStudent,
      data: data, 
      options: Options(headers: {'Content-Type': 'application/json'}),
    );
    
    return LoginResponseModel.fromJson(response.data);
  } on DioException catch (e) {
    throw Exception(e.response?.data['message'] ?? 'An error occurred.');
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
  Future<ForgotPasswordResponseModel> forgotPassword(ForgotPasswordRequestModel request) async {
    try {
      final response = await _dio.post(
        ApiConstants.forgotPassword,
        data: request.toJson(),
      );
      return ForgotPasswordResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to send verification code.');
    }
  }

  @override
  Future<VerifyResetCodeResponseModel> verifyResetCode(VerifyResetCodeRequestModel request) async {
    try {
      final response = await _dio.post(
        ApiConstants.verifyResetCode,
        data: request.toJson(),
      );
      return VerifyResetCodeResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'The entered code is incorrect.');
    }
  }

  @override
  Future<ResetPasswordResponseModel> resetPassword(ResetPasswordRequestModel request) async {
    try {
      final response = await _dio.post(
        ApiConstants.resetPassword,
        data: request.toJson(),
      );
      return ResetPasswordResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to reset password');
    }
  }
}