import '../../data/repositories/auth_repository_impl.dart';
import '../../data/models/login_response_model.dart';

class LoginUseCase {
  final AuthRepositoryImpl repository;

  LoginUseCase({required this.repository});

  Future<LoginResponseModel> execute(String email, String password) {
    return repository.login(email, password);
  }
}