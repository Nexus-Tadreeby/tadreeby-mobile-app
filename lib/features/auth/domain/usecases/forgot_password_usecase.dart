import '../../data/models/forgot_password_request_model.dart';
import '../../data/models/forgot_password_response_model.dart';
import '../../data/repositories/auth_repository_impl.dart';

class ForgotPasswordUseCase {
  final AuthRepositoryImpl repository;

  ForgotPasswordUseCase({required this.repository});

  Future<ForgotPasswordResponseModel> execute(ForgotPasswordRequestModel request) {
    return repository.forgotPassword(request);
  }
}