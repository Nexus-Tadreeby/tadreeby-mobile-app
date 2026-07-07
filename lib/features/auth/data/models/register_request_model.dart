import 'package:dio/dio.dart';

class RegisterRequestModel {
  final String firstName;
  final String lastName;
  final int personalID;
  final num studentNumber;
  final String phone;
  final String email;
  final String password;
  final String confirmPassword;
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
    required this.confirmPassword,
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
      'confirmPassword': confirmPassword,
      'universityId': universityId,
      'major': major,
      'verificationDocument': await MultipartFile.fromFile(
        verificationDocumentPath,
        filename: verificationDocumentPath.split('/').last,
      ),
    });
  }

  void printData() {
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print(' Registration Data:');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('firstName: $firstName');
    print('lastName: $lastName');
    print('personalID: $personalID');
    print('studentNumber: $studentNumber');
    print('phone: $phone');
    print('email: $email');
    print('password: ${"*" * password.length}');
    print('confirmPassword: ${"*" * confirmPassword.length}');
    print('universityId: $universityId');
    print('major: $major');
    print('verificationDocumentPath: $verificationDocumentPath');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  }
}