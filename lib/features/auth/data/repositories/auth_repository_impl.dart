import '../../domain/repositories/auth_repository.dart';
import '../data_sources/auth_remote_data_source.dart';
import '../models/login_response_model.dart';
import '../models/register_request_model.dart';

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
  Future<String> forgotPassword(String email) {
    return remoteDataSource.forgotPassword(email);
  }

  @override
  Future<String> verifyResetCode(String email, String code) {
    return remoteDataSource.verifyResetCode(email, code);
  }

  @override
  Future<bool> resetPassword(String resetToken, String newPassword) {
    return remoteDataSource.resetPassword(resetToken, newPassword);
  }
}