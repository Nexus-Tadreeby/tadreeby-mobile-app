import '../../domain/repositories/auth_repository.dart';
import '../data_sources/auth_remote_data_source.dart';
import '../models/login_response_model.dart';
import '../models/register_request_model.dart';
import '../models/forgot_password_request_model.dart';
import '../models/verify_reset_code_request_model.dart';
import '../models/reset_password_request_model.dart';
import '../models/forgot_password_response_model.dart';
import '../models/verify_reset_code_response_model.dart';
import '../models/reset_password_response_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<LoginResponseModel> login(String email, String password) {
    return remoteDataSource.login(email, password);
  }

  @override
  Future<LoginResponseModel> registerStudent(RegisterRequestModel request) {
    return remoteDataSource.registerStudent(request);
  }

  @override
  Future<void> logout(String refreshToken) {
    return remoteDataSource.logout(refreshToken);
  }
 @override
  Future<ForgotPasswordResponseModel> forgotPassword(ForgotPasswordRequestModel request) {
    return remoteDataSource.forgotPassword(request);
  }

  @override
  Future<VerifyResetCodeResponseModel> verifyResetCode(VerifyResetCodeRequestModel request) {
    return remoteDataSource.verifyResetCode(request);
  }

  @override
  Future<ResetPasswordResponseModel> resetPassword(ResetPasswordRequestModel request) {
    return remoteDataSource.resetPassword(request);
  }
}