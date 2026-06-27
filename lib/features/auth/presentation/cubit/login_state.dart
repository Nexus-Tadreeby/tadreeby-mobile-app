import '../../data/models/login_response_model.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final UserModel user;
  final String accessToken;
  final String refreshToken;
  final String sessionId;

  LoginSuccess({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
    required this.sessionId,
  });
}

class LoginError extends LoginState {
  final String message;

  LoginError({required this.message});
}