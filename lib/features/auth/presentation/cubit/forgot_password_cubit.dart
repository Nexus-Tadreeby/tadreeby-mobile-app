// lib/features/auth/presentation/cubit/forgot_password_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tadreeby/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:tadreeby/features/auth/domain/usecases/verify_reset_code_usecase.dart';
import 'package:tadreeby/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:tadreeby/features/auth/data/models/forgot_password_request_model.dart';
import 'package:tadreeby/features/auth/data/models/verify_reset_code_request_model.dart';
import 'package:tadreeby/features/auth/data/models/reset_password_request_model.dart';
import 'forgot_password_state.dart';

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// FORGOT PASSWORD CUBIT
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final ForgotPasswordUseCase forgotPasswordUseCase;
  final VerifyResetCodeUseCase verifyResetCodeUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;

  ForgotPasswordCubit({
    required this.forgotPasswordUseCase,
    required this.verifyResetCodeUseCase,
    required this.resetPasswordUseCase,
  }) : super(ForgotPasswordInitial());

  // ─── 1️ Send Verification Code ──────────────────────────────
  Future<void> sendVerificationCode(String email) async {
    emit(ForgotPasswordLoading());
    try {
      final request = ForgotPasswordRequestModel(email: email);
      final response = await forgotPasswordUseCase.execute(request);
      emit(ForgotPasswordSuccess(response));
    } catch (e) {
      emit(ForgotPasswordError(
        message: _getErrorMessage(e.toString()),
      ));
    }
  }

  // ─── 2️ Verify Reset Code ──────────────────────────────────
  Future<void> verifyCode(String email, String code) async {
    emit(VerifyResetCodeLoading());
    try {
      final request = VerifyResetCodeRequestModel(
        email: email,
        code: code,
      );
      final response = await verifyResetCodeUseCase.execute(request);
      emit(VerifyResetCodeSuccess(response));
    } catch (e) {
      emit(VerifyResetCodeError(
        message: _getErrorMessage(e.toString()),
      ));
    }
  }

  // ─── 3️ Reset Password ──────────────────────────────────────
  Future<void> resetPassword(String resetToken, String newPassword) async {
    emit(ResetPasswordLoading());
    try {
      final request = ResetPasswordRequestModel(
        resetToken: resetToken,
        newPassword: newPassword,
      );
      final response = await resetPasswordUseCase.execute(request);
      emit(ResetPasswordSuccess(response));
    } catch (e) {
      emit(ResetPasswordError(
        message: _getErrorMessage(e.toString()),
      ));
    }
  }

  // ─── 4️ Reset to Initial State ──────────────────────────────
  void resetToInitial() {
    emit(ForgotPasswordInitial());
  }

  // ─── 5️ Reset to Email Step (after error) ───────────────────
  void resetToEmailStep() {
    emit(ForgotPasswordInitial());
  }

  // ─── 6️ Helper: Get User-Friendly Error Messages ────────────
  String _getErrorMessage(String error) {

      if (error.contains('Can\'t find user') || 
      error.contains("Can't find user") || 
      error.contains('email') && error.contains('registered')) {
    return 'This email address is not registered. Please check your email or create a new account.';
  }
  
    if (error.contains('email')) {
      return 'Please enter a valid email address.';
    } else if (error.contains('code') || error.contains('incorrect')) {
      return 'The verification code is incorrect. Please try again.';
    } else if (error.contains('expired') || error.contains('expire')) {
      return 'The verification code has expired. Please request a new one.';
    } else if (error.contains('password') || error.contains('Password')) {
      return 'Please enter a valid password. Password must be at least 8 characters.';
    } else if (error.contains('network') || error.contains('connection')) {
      return 'Network error. Please check your internet connection.';
    } else if (error.contains('server') || error.contains('Server')) {
      return 'Server error. Please try again later.';
    } else if (error.contains('timeout')) {
      return 'Request timed out. Please try again.';
    }
   
    return error;
  }
}