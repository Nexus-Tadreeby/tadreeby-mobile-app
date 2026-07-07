import '../../data/models/reset_password_request_model.dart';
import '../../data/models/reset_password_response_model.dart';
import '../../data/repositories/auth_repository_impl.dart';

class ResetPasswordUseCase {
  final AuthRepositoryImpl repository;

  ResetPasswordUseCase({required this.repository});

  Future<ResetPasswordResponseModel> execute(ResetPasswordRequestModel request) {
    return repository.resetPassword(request);
  }
}