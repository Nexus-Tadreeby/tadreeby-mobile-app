// lib/core/router/app_router.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:tadreeby/core/theme/app_colors.dart';
import 'package:tadreeby/features/admin/presentation/cubits/create_university_cubit.dart';
import 'package:tadreeby/features/admin/presentation/cubits/university_cubit.dart';
import 'package:tadreeby/features/admin/presentation/cubits/users_cubit.dart';
import 'package:tadreeby/features/admin/presentation/screens/users_list_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_step1_screen.dart';
import '../../features/auth/presentation/screens/register_step2_screen.dart';
import '../../features/auth/presentation/screens/register_step3_screen.dart';
import '../../features/auth/presentation/screens/forgot_password/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/forgot_password/check_email_screen.dart';
import '../../features/auth/presentation/screens/forgot_password/create_new_password_screen.dart';
import '../../features/auth/presentation/screens/forgot_password/password_updated_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';

// ─── Admin Screens ─────────────────────────────────────────────
import '../../features/admin/presentation/screens/universities_list_screen.dart';
import '../../features/admin/presentation/screens/create_university_screen.dart';
import '../../features/admin/presentation/screens/admin_dashboard_screen.dart'; 
import '../../features/admin/presentation/screens/university_details_screen.dart';
import '../../features/admin/presentation/screens/companies_list_screen.dart';
// import '../../features/admin/presentation/screens/create_company_screen.dart';
 import '../../features/admin/presentation/screens/company_details_screen.dart';
import '../../features/admin/presentation/cubits/company_cubit.dart';
import '../../features/admin/presentation/cubits/create_company_cubit.dart';
import '../../features/admin/presentation/cubits/university_cubit.dart';

import '../utils/secure_storage_service.dart';
import '../di/injection.dart'; 

class AppRouter {
  // ─── Auth Routes ──────────────────────────────────────────────
  static const String login = '/login';
  static const String registerStep1 = '/register/step1';
  static const String registerStep2 = '/register/step2';
  static const String registerStep3 = '/register/step3';
  static const String forgotPassword = '/forgot-password';
  static const String checkEmail = '/check-email';
  static const String createNewPassword = '/create-new-password';
  static const String passwordUpdated = '/password-updated';

  // ─── Onboarding ──────────────────────────────────────────────
  static const String onboarding = '/onboarding';

  // ─── Student Routes ──────────────────────────────────────────
  static const String studentDashboard = '/student/dashboard';
  static const String pendingStatus = '/pending-status';
  static const String rejectedStatus = '/rejected-status';

  // ─── Admin Routes ────────────────────────────────────────────
  static const String adminDashboard = '/admin/dashboard';
  static const String adminUniversities = '/admin/universities';
  static const String adminCreateUniversity = '/admin/universities/create';
  static const String adminUniversityDetails = '/admin/universities/:id';
  static const String adminUsers = '/admin/users';

  // ─── Company Routes ──────────────────────────────────────────
  static const String companyDashboard = '/company/dashboard';
static const String adminCompanies = '/admin/companies';
static const String adminCreateCompany = '/admin/companies/create';
static const String adminCompanyDetails = '/admin/companies/:id';
  // ─── University Routes ──────────────────────────────────────
  static const String universityDashboard = '/university/dashboard';

  // ─── Default ──────────────────────────────────────────────────
  static const String dashboard = '/dashboard';

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

        print('👤 User Role: $role');
        print('📌 Approval Status: $approvalStatus');

        // ─── Student Approval Status Handling ────────────────────
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
            return studentDashboard;
          }
        }

        // ─── If user is on auth route and logged in ──────────────
        if (isAuthRoute) {
          return _getDashboardRoute(role);
        }

        // ─── Check if user has access to the route ──────────────
        final isAdminRoute = state.matchedLocation.startsWith('/admin');
        final isStudentRoute = state.matchedLocation.startsWith('/student');
        final isCompanyRoute = state.matchedLocation.startsWith('/company');
        final isUniversityRoute = state.matchedLocation.startsWith('/university');

        // ─── Admin Access Control ─────────────────────────────────
        if (isAdminRoute) {
          if (role != 'SUPER_ADMIN' && role != 'UNIVERSITY_ADMIN') {
            return _getDashboardRoute(role);
          }
          return null; // Allow admin to access admin routes
        }

        if (isStudentRoute && role != 'STUDENT') {
          return _getDashboardRoute(role);
        }

        if (isCompanyRoute && role != 'COMPANY') {
          return _getDashboardRoute(role);
        }

        if (isUniversityRoute && role != 'UNIVERSITY' && role != 'UNIVERSITY_ADMIN') {
          return _getDashboardRoute(role);
        }

        return null;
      } catch (e) {
        print('❌ Error in redirect: $e');
        return login;
      }
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

      // ─── Onboarding ──────────────────────────────────────
      GoRoute(
        path: onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),

      // ─── Student Routes ──────────────────────────────────
      GoRoute(
        path: studentDashboard,
        builder: (context, state) => const _UnderDevelopmentScreen(
          title: 'Student Dashboard',
        ),
      ),
      GoRoute(
        path: pendingStatus,
        builder: (context, state) => const _UnderDevelopmentScreen(
          title: 'Pending Status',
        ),
      ),
      GoRoute(
        path: rejectedStatus,
        builder: (context, state) => const _UnderDevelopmentScreen(
          title: 'Rejected Status',
        ),
      ),

      // ─── Admin Routes ────────────────────────────────────
      GoRoute(
        path: adminDashboard,
        builder: (context, state) => const AdminDashboardScreen(),
      ),
      GoRoute(
        path: adminUniversities,
        builder: (context, state) => BlocProvider(
          create: (context) => getIt<UniversityCubit>(),
          child: const UniversitiesListScreen(),
        ),
      ),
      GoRoute(
        path: adminCreateUniversity,
        builder: (context, state) => BlocProvider(
          create: (context) => getIt<CreateUniversityCubit>(),
          child: const CreateUniversityScreen(),
        ),
      ),
 GoRoute(
  path: adminUniversityDetails,
  builder: (context, state) {
    final id = int.parse(state.pathParameters['id']!);
    return BlocProvider(
      create: (context) => getIt<UniversityCubit>(),
      child: UniversityDetailsScreen(universityId: id),
    );
  },
),

      // ─── Company Routes ──────────────────────────────────
      GoRoute(
        path: companyDashboard,
        builder: (context, state) => const _UnderDevelopmentScreen(
          title: 'Company Dashboard',
        ),
      ),

      // ─── University Routes ──────────────────────────────
      GoRoute(
        path: universityDashboard,
        builder: (context, state) => const _UnderDevelopmentScreen(
          title: 'University Dashboard',
        ),
      ),

      // ─── Default Dashboard ──────────────────────────────
      GoRoute(
        path: dashboard,
        builder: (context, state) => const _UnderDevelopmentScreen(
          title: 'Dashboard',
        ),
      ),
      GoRoute(
  path: adminCompanies,
  builder: (context, state) => BlocProvider(
    create: (context) => getIt<CompanyCubit>(),
    child: const CompaniesListScreen(),
  ),
),
// GoRoute(
//   path: adminCreateCompany,
//   builder: (context, state) => BlocProvider(
//     create: (context) => getIt<CreateCompanyCubit>(),
//     child: const CreateCompanyScreen(),
//   ),
// ),
GoRoute(
  path: adminCompanyDetails,
  builder: (context, state) {
    final id = int.parse(state.pathParameters['id']!);
    return CompanyDetailsScreen(companyId: id);
  },
),

GoRoute(
  path: adminUsers,
  builder: (context, state) => BlocProvider(
    create: (context) => getIt<UsersCubit>(),
    child: const UsersListScreen(),
  ),
),
    ],
  );
  

  // ─── Helper: Get Dashboard Route Based on Role ──────────────
  static String _getDashboardRoute(String role) {
    switch (role) {
      case 'STUDENT':
        return studentDashboard;
      case 'SUPER_ADMIN':
        return adminDashboard;
      case 'UNIVERSITY_ADMIN':
        return adminDashboard;
      case 'COMPANY':
        return companyDashboard;
      case 'UNIVERSITY':
        return universityDashboard;
      default:
        return dashboard;
    }
  }
}

// ─── Under Development Screen ──────────────────────────────────
class _UnderDevelopmentScreen extends StatelessWidget {
  final String title;
  final String? subtitle;

  const _UnderDevelopmentScreen({
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction_outlined,
              size: 64,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle ?? 'This screen is currently under development.',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textGrey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '🚧 Coming Soon 🚧',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}