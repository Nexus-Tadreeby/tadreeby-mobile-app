import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

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
      
      // ✅ التحقق من وجود الملف
      if (!await file.exists()) {
        throw Exception('File does not exist: ${requestModel.verificationDocumentPath}');
      }
      
      final fileBytes = await file.readAsBytes();
      final fileSize = fileBytes.length;
      final fileName = file.path.split('/').last;
      
      print('📁 File size: ${(fileSize / 1024).toStringAsFixed(1)} KB');
      print('📁 File name: $fileName');
      
      Uint8List uploadBytes = fileBytes;
      if (fileSize > 2 * 1024 * 1024 && 
          (fileName.endsWith('.jpg') || fileName.endsWith('.jpeg') || fileName.endsWith('.png'))) {
        try {
          print('📸 Compressing large image...');
          final codec = await ui.instantiateImageCodec(
            fileBytes,
            targetWidth: 600,
            targetHeight: 600,
          );
          final frame = await codec.getNextFrame();
          final image = frame.image;
          final byteData = await image.toByteData(
            format: ui.ImageByteFormat.png,
          );
          uploadBytes = byteData!.buffer.asUint8List();
          print('📸 Compressed: ${(fileSize / 1024).toStringAsFixed(1)} KB → ${(uploadBytes.length / 1024).toStringAsFixed(1)} KB');
        } catch (e) {
          print('⚠️ Compression failed, using original: $e');
        }
      }
      
      final multipartFile = MultipartFile.fromBytes(
        uploadBytes,
        filename: fileName,
        contentType: DioMediaType('image', 'jpeg'),
      );
      
      final formData = FormData.fromMap({
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
        'verificationDocument': multipartFile,
      });
      
      print('📤 Sending registration request with multipart/form-data');
      
      final response = await _dio.post(
        ApiConstants.registerStudent,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
          maxRedirects: 5,
        ),
      );
      
      print('📥 Response status: ${response.statusCode}');
      
      return LoginResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      print('❌ Dio Error: ${e.response?.statusCode}');
      print('❌ Response data: ${e.response?.data}');
      print('❌ Error message: ${e.message}');
      
      String errorMessage = 'An error occurred during registration.';
      if (e.response?.data != null) {
        try {
          final data = e.response?.data;
          if (data is Map) {
            errorMessage = data['message'] ?? errorMessage;
          } else if (data is String) {
            errorMessage = data;
          }
        } catch (_) {}
      }
      
      throw Exception(errorMessage);
    }
  }

// @override
// Future<LoginResponseModel> registerStudent(RegisterRequestModel requestModel) async {
// //   try {
// //     final file = File(requestModel.verificationDocumentPath);
// //     final bytes = await file.readAsBytes();
// //     final base64File = base64Encode(bytes);
    
// //     final data = {
// //       'firstName': requestModel.firstName,
// //       'lastName': requestModel.lastName,
// //       'personalID': requestModel.personalID,
// //       'studentNumber': requestModel.studentNumber,
// //       'phone': requestModel.phone,
// //       'email': requestModel.email,
// //       'password': requestModel.password,
// //       'confirmPassword': requestModel.confirmPassword,
// //       'universityId': requestModel.universityId,
// //       'major': requestModel.major,
// //       'verificationDocument': base64File,
// //     };
    
    
// //     final response = await _dio.post(
// //       ApiConstants.registerStudent,
// //       data: data, 
// //       options: Options(headers: {'Content-Type': 'application/json'}),
// //     );
    
// //     return LoginResponseModel.fromJson(response.data);
// //   } on DioException catch (e) {
// //     throw Exception(e.response?.data['message'] ?? 'An error occurred.');
// //   }
// // }

//  try {
//       final file = File(requestModel.verificationDocumentPath);
//       Uint8List bytes = await file.readAsBytes();
      
//       print('📸 Original file size: ${(bytes.length / 1024).toStringAsFixed(1)} KB');
      
//       // ✅ ضغط الصورة بقوة (حتى لو كانت صغيرة، نضغطها لتقليل الحجم)
//       try {
//         // ضغط الصورة إلى أبعاد صغيرة وجودة منخفضة
//         final codec = await ui.instantiateImageCodec(
//           bytes,
//           targetWidth: 400,    // عرض صغير
//           targetHeight: 400,   // ارتفاع صغير
//         );
//         final frame = await codec.getNextFrame();
//         final image = frame.image;
//         final byteData = await image.toByteData(
//           format: ui.ImageByteFormat.png,
//         );
//         bytes = byteData!.buffer.asUint8List();
//         print('📸 Compressed size: ${(bytes.length / 1024).toStringAsFixed(1)} KB');
//       } catch (e) {
//         print('⚠️ Compression failed, using original: $e');
//         // إذا فشل الضغط، نستمر بالصورة الأصلية
//       }
      
//       // ✅ تحويل إلى Base64
//       final base64File = base64Encode(bytes);
//       print('📸 Base64 size: ${(base64File.length / 1024).toStringAsFixed(1)} KB');
//       print('📸 Total request size: ${((base64File.length + 500) / 1024).toStringAsFixed(1)} KB');
      
//       final data = {
//         'firstName': requestModel.firstName,
//         'lastName': requestModel.lastName,
//         'personalID': requestModel.personalID,
//         'studentNumber': requestModel.studentNumber,
//         'phone': requestModel.phone,
//         'email': requestModel.email,
//         'password': requestModel.password,
//         'confirmPassword': requestModel.confirmPassword,
//         'universityId': requestModel.universityId,
//         'major': requestModel.major,
//         'verificationDocument': base64File,
//       };
      
//       final response = await _dio.post(
//         ApiConstants.registerStudent,
//         data: data,
//         options: Options(
//           headers: {'Content-Type': 'application/json'},
//           maxRedirects: 5,
//         ),
//       );
      
//       return LoginResponseModel.fromJson(response.data);
//     } on DioException catch (e) {
//       print('❌ Dio Error: ${e.response?.statusCode}');
//       print('❌ Response data: ${e.response?.data}');
//       print('❌ Error message: ${e.message}');
//       throw Exception(e.response?.data['message'] ?? 'An error occurred.');
//     }
//   }

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