import '../../data/models/verify_reset_code_request_model.dart';
import '../../data/models/verify_reset_code_response_model.dart';
import '../../data/repositories/auth_repository_impl.dart';

class VerifyResetCodeUseCase {
  final AuthRepositoryImpl repository;

  VerifyResetCodeUseCase({required this.repository});

  Future<VerifyResetCodeResponseModel> execute(VerifyResetCodeRequestModel request) {
    return repository.verifyResetCode(request);
  }
}