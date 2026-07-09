import '../../data/models/login_response_model.dart';
import '../../data/models/register_request_model.dart';
import '../../data/repositories/auth_repository_impl.dart';

class RegisterUseCase {
  final AuthRepositoryImpl repository;

  RegisterUseCase({required this.repository});

  Future<LoginResponseModel> execute(RegisterRequestModel request) {
    return repository.registerStudent(request);
  }
}