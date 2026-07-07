// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tadreeby/core/di/injection.dart';
import 'package:tadreeby/core/router/app_router.dart';
import 'package:tadreeby/core/services/token_refresh_service.dart';
import 'package:tadreeby/features/admin/presentation/cubits/company_cubit.dart';
import 'package:tadreeby/features/auth/presentation/cubit/login_cubit.dart';
import 'package:tadreeby/features/auth/presentation/cubit/register_cubit.dart';
import 'package:tadreeby/features/auth/presentation/cubit/forgot_password_cubit.dart';
import 'package:tadreeby/features/auth/presentation/cubit/register_data_cubit.dart';

void main() {
  setupLocator();
    TokenRefreshService().startAutoRefresh();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  late final TokenRefreshService _tokenRefreshService;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // ✅ إنشاء الخدمة
    _tokenRefreshService = TokenRefreshService();
    _tokenRefreshService.startAutoRefresh();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _tokenRefreshService.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      print('🔄 App resumed - refreshing token...');
      _tokenRefreshService.refreshImmediately();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RegisterDataCubit>(
          create: (_) => getIt<RegisterDataCubit>(),
        ),
        BlocProvider<LoginCubit>(
          create: (context) => getIt<LoginCubit>(),
        ),
        BlocProvider<RegisterCubit>(
          create: (context) => getIt<RegisterCubit>(),
        ),
        BlocProvider<ForgotPasswordCubit>(
          create: (context) => getIt<ForgotPasswordCubit>(),
        ),
           BlocProvider<CompanyCubit>(
          create: (context) => getIt<CompanyCubit>(),
        ),
      ],
      child: MaterialApp.router(
        title: 'Tadreeby',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Poppins',
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFF47920),
            primary: const Color(0xFFF47920),
          ),
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            iconTheme: IconThemeData(color: Colors.black),
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 0,
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xffC2DCFF), width: 1.2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xffC2DCFF), width: 1.2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF1677FF), width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 1.2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 16,
            ),
          ),
        ),
        routerConfig: AppRouter.router,
      ),
    );
  }
}