// lib/core/router/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_step1_screen.dart';
import '../../features/auth/presentation/screens/register_step2_screen.dart';
import '../../features/auth/presentation/screens/register_step3_screen.dart';
import '../../features/auth/presentation/screens/forgot_password/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/forgot_password/check_email_screen.dart';
import '../../features/auth/presentation/screens/forgot_password/create_new_password_screen.dart';
import '../../features/auth/presentation/screens/forgot_password/password_updated_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../utils/secure_storage_service.dart';

class AppRouter {
  static const String login = '/login';
  static const String registerStep1 = '/register/step1';
  static const String registerStep2 = '/register/step2';
  static const String registerStep3 = '/register/step3';
  static const String pendingStatus = '/pending-status';
  static const String dashboard = '/dashboard';
  static const String rejectedStatus = '/rejected-status';
  static const String onboarding = '/onboarding';
  
  static const String forgotPassword = '/forgot-password';
  static const String checkEmail = '/check-email';
  static const String createNewPassword = '/create-new-password';
  static const String passwordUpdated = '/password-updated';

  static final SecureStorageService _storageService = SecureStorageService();

  static final GoRouter router = GoRouter(
    initialLocation: onboarding,
    redirect: (BuildContext context, GoRouterState state) async {
    print('🔀 Redirect called for: ${state.matchedLocation}');
    
    final accessToken = await _storageService.getAccessToken();
    final hasSeenOnboarding = await _storageService.hasSeenOnboarding();
    
    print('📌 hasSeenOnboarding: $hasSeenOnboarding');
    print('📌 accessToken: ${accessToken != null ? "Exists" : "null"}');

    if (!hasSeenOnboarding) {
      print('🚀 Going to Onboarding (hasSeenOnboarding = false)');
      return onboarding;
    }
      final isAuthRoute = state.matchedLocation == login ||
          state.matchedLocation == registerStep1 ||
          state.matchedLocation == registerStep2 ||
          state.matchedLocation == registerStep3 ||
          state.matchedLocation == onboarding ||
          state.matchedLocation == forgotPassword ||
          state.matchedLocation == checkEmail ||
          state.matchedLocation == createNewPassword ||
          state.matchedLocation == passwordUpdated;

      if (accessToken == null) {
        return isAuthRoute ? null : login;
      }

      try {
        Map<String, dynamic> decodedToken = JwtDecoder.decode(accessToken);
        String role = decodedToken['role'] ?? 'STUDENT';
        String approvalStatus =
            decodedToken['studentProfile']?['approvalStatus'] ?? 'PENDING';

        if (role == 'STUDENT') {
          if (approvalStatus == 'PENDING' &&
              state.matchedLocation != pendingStatus) {
            return pendingStatus;
          }
          if (approvalStatus == 'REJECTED' &&
              state.matchedLocation != rejectedStatus) {
            return rejectedStatus;
          }
          if (approvalStatus == 'ACTIVE' &&
              (state.matchedLocation == pendingStatus ||
                  state.matchedLocation == rejectedStatus)) {
            return dashboard;
          }
        }

        if (isAuthRoute) {
          return dashboard;
        }
      } catch (e) {
        return login;
      }

      return null;
    },

    routes: [
      // ─── Auth Routes ──────────────────────────────────────
      GoRoute(
        path: login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: registerStep1,
        builder: (context, state) => const RegisterStep1Screen(),
      ),
      GoRoute(
        path: registerStep2,
        builder: (context, state) => const RegisterStep2Screen(),
      ),
      GoRoute(
        path: registerStep3,
        builder: (context, state) => const RegisterStep3Screen(),
      ),

      // ─── Forgot Password Routes ───────────────────────────
      GoRoute(
        path: forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: checkEmail,
        builder: (context, state) => const CheckEmailScreen(),
      ),
      GoRoute(
        path: createNewPassword,
        builder: (context, state) => const CreateNewPasswordScreen(),
      ),
      GoRoute(
        path: passwordUpdated,
        builder: (context, state) => const PasswordUpdatedScreen(),
      ),

      // ─── Other Routes ──────────────────────────────────────
      GoRoute(
        path: onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: pendingStatus,
        builder: (context, state) => const Placeholder(),
      ),
      GoRoute(
        path: rejectedStatus,
        builder: (context, state) => const Placeholder(),
      ),
      GoRoute(
        path: dashboard,
        builder: (context, state) => const Placeholder(),
      ),
    ],
  );
}