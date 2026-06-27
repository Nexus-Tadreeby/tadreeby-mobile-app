import '../../data/models/login_response_model.dart';
import '../../data/models/register_request_model.dart';

abstract class AuthRepository {
  Future<LoginResponseModel> login(String email, String password);
  Future<LoginResponseModel> registerStudent(RegisterRequestModel request);
  Future<void> logout(String refreshToken);
  Future<String> forgotPassword(String email);
  Future<String> verifyResetCode(String email, String code);
  Future<bool> resetPassword(String resetToken, String newPassword);
}