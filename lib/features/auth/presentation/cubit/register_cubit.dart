import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tadreeby/features/auth/data/models/register_request_model.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../data/models/login_response_model.dart';

// ─── States ──────────────────────────────────────────────
abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final LoginResponseModel response;
  RegisterSuccess(this.response);
}

class RegisterError extends RegisterState {
  final String message;
  RegisterError({required this.message}); 
}

// ─── Cubit ────────────────────────────────────────────────
class RegisterCubit extends Cubit<RegisterState> {
  final RegisterUseCase registerUseCase;

  RegisterCubit({required this.registerUseCase}) : super(RegisterInitial());

  Future<void> register(RegisterRequestModel request) async {
    emit(RegisterLoading());

    try {
      final response = await registerUseCase.execute(request);
      emit(RegisterSuccess(response));
    } catch (e) {
      emit(RegisterError(message: e.toString()));
    }
  }
}