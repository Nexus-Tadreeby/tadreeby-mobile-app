import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/login_usecase.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase loginUseCase;

  LoginCubit({required this.loginUseCase}) : super(LoginInitial());

  Future<void> login(String email, String password) async {
    emit(LoginLoading());
    try {
      final response = await loginUseCase.execute(email, password);
      emit(LoginSuccess(
        user: response.user,
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
        sessionId: response.sessionId,
      ));
    } catch (e) {
      emit(LoginError(message: e.toString()));
    }
  }
}