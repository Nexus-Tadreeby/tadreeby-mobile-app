import '../../data/models/forgot_password_response_model.dart';
import '../../data/models/verify_reset_code_response_model.dart';
import '../../data/models/reset_password_response_model.dart';

abstract class ForgotPasswordState {}

class ForgotPasswordInitial extends ForgotPasswordState {}

// ─── Forgot Password States ──────────────────────────────
class ForgotPasswordLoading extends ForgotPasswordState {}

class ForgotPasswordSuccess extends ForgotPasswordState {
  final ForgotPasswordResponseModel response;
  ForgotPasswordSuccess(this.response);
}

class ForgotPasswordError extends ForgotPasswordState {
  final String message;
  ForgotPasswordError({required this.message});
}

// ─── Verify Reset Code States ──────────────────────────────
class VerifyResetCodeLoading extends ForgotPasswordState {}

class VerifyResetCodeSuccess extends ForgotPasswordState {
  final VerifyResetCodeResponseModel response;
  VerifyResetCodeSuccess(this.response);
}

class VerifyResetCodeError extends ForgotPasswordState {
  final String message;
  VerifyResetCodeError({required this.message});
}

// ─── Reset Password States ──────────────────────────────────
class ResetPasswordLoading extends ForgotPasswordState {}

class ResetPasswordSuccess extends ForgotPasswordState {
  final ResetPasswordResponseModel response;
  ResetPasswordSuccess(this.response);
}

class ResetPasswordError extends ForgotPasswordState {
  final String message;
  ResetPasswordError({required this.message});
}