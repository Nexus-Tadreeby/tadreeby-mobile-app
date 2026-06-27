import 'package:dio/dio.dart';

class RegisterRequestModel {
  final String firstName;
  final String lastName;
  final int personalID;
  final int studentNumber;
  final String phone;
  final String email;
  final String password;
  final int universityId;
  final String major;
  final String verificationDocumentPath; 

  RegisterRequestModel({
    required this.firstName,
    required this.lastName,
    required this.personalID,
    required this.studentNumber,
    required this.phone,
    required this.email,
    required this.password,
    required this.universityId,
    required this.major,
    required this.verificationDocumentPath,
  });

  Future<FormData> toFormData() async {
    return FormData.fromMap({
      'firstName': firstName,
      'lastName': lastName,
      'personalID': personalID,
      'studentNumber': studentNumber,
      'phone': phone,
      'email': email,
      'password': password,
      'universityId': universityId,
      'major': major,
      'verificationDocument': await MultipartFile.fromFile(
        verificationDocumentPath,
        filename: verificationDocumentPath.split('/').last, 
      ),
    });
  }
}