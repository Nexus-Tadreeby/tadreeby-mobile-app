import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tadreeby/core/utils/secure_storage_service.dart';
import '../../domain/usecases/login_usecase.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase loginUseCase;
  final SecureStorageService _storageService = SecureStorageService();

  LoginCubit({required this.loginUseCase}) : super(LoginInitial());

  Future<void> login(String email, String password) async {
    emit(LoginLoading());
    try {
      final response = await loginUseCase.execute(email, password);
      
      await _storageService.saveAccessToken(response.accessToken);
      await _storageService.saveRefreshToken(response.refreshToken);
      
      print('✅ Tokens saved successfully!');
      print('📌 Access Token: ${response.accessToken.substring(0, 30)}...');
      print('📌 Refresh Token: ${response.refreshToken.substring(0, 30)}...');
      
      emit(LoginSuccess(
        user: response.user,
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
        sessionId: response.sessionId,
      ));
    } catch (e) {
      print('❌ Login Error: $e');
      emit(LoginError(message: e.toString()));
    }
  }
}