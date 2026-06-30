import '../../data/models/login_response_model.dart';
import '../../data/models/register_request_model.dart';
import '../../data/models/forgot_password_request_model.dart';
import '../../data/models/verify_reset_code_request_model.dart';
import '../../data/models/reset_password_request_model.dart';
import '../../data/models/forgot_password_response_model.dart';
import '../../data/models/verify_reset_code_response_model.dart';
import '../../data/models/reset_password_response_model.dart';

abstract class AuthRepository {
  Future<LoginResponseModel> login(String email, String password);
  Future<LoginResponseModel> registerStudent(RegisterRequestModel request);
  Future<void> logout(String refreshToken);
  
  Future<ForgotPasswordResponseModel> forgotPassword(ForgotPasswordRequestModel request);
  Future<VerifyResetCodeResponseModel> verifyResetCode(VerifyResetCodeRequestModel request);
  Future<ResetPasswordResponseModel> resetPassword(ResetPasswordRequestModel request);
}