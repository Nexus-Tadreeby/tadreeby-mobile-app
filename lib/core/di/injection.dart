// lib/core/di/injection.dart
import 'package:get_it/get_it.dart';
import 'package:tadreeby/core/network/dio_client.dart';
import 'package:tadreeby/core/utils/secure_storage_service.dart';
import 'package:tadreeby/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:tadreeby/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:tadreeby/features/auth/domain/repositories/auth_repository.dart';
import 'package:tadreeby/features/auth/domain/usecases/login_usecase.dart';
import 'package:tadreeby/features/auth/domain/usecases/register_usecase.dart';
import 'package:tadreeby/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:tadreeby/features/auth/domain/usecases/verify_reset_code_usecase.dart';
import 'package:tadreeby/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:tadreeby/features/auth/presentation/cubit/login_cubit.dart';
import 'package:tadreeby/features/auth/presentation/cubit/register_cubit.dart';
import 'package:tadreeby/features/auth/presentation/cubit/forgot_password_cubit.dart';
import 'package:tadreeby/features/auth/presentation/cubit/register_data_cubit.dart';

final GetIt getIt = GetIt.instance;

void setupLocator() {
  // ─── Core Services ──────────────────────────────────────────
  getIt.registerLazySingleton<SecureStorageService>(
    () => SecureStorageService(),
  );

  getIt.registerLazySingleton<DioClient>(
    () => DioClient(),
  );

  // ─── Remote Data Source ────────────────────────────────────
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      getIt<DioClient>(),
    ),
  );

  // ─── Repository ────────────────────────────────────────────
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt<AuthRemoteDataSource>(),
    ),
  );

  // ─── Use Cases ─────────────────────────────────────────────
  getIt.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(
      repository: getIt<AuthRepository>() as AuthRepositoryImpl,
    ),
  );

  getIt.registerLazySingleton<RegisterUseCase>(
    () => RegisterUseCase(
      repository: getIt<AuthRepository>() as AuthRepositoryImpl,
    ),
  );

  getIt.registerLazySingleton<ForgotPasswordUseCase>(
    () => ForgotPasswordUseCase(
      repository: getIt<AuthRepository>() as AuthRepositoryImpl,
    ),
  );

  getIt.registerLazySingleton<VerifyResetCodeUseCase>(
    () => VerifyResetCodeUseCase(
      repository: getIt<AuthRepository>() as AuthRepositoryImpl,
    ),
  );

  getIt.registerLazySingleton<ResetPasswordUseCase>(
    () => ResetPasswordUseCase(
      repository: getIt<AuthRepository>() as AuthRepositoryImpl,
    ),
  );

  // ─── Cubits (Factory - new instance each time) ────────────
  getIt.registerFactory<LoginCubit>(
    () => LoginCubit(
      loginUseCase: getIt<LoginUseCase>(),
    ),
  );

  getIt.registerFactory<RegisterCubit>(
    () => RegisterCubit(
      registerUseCase: getIt<RegisterUseCase>(),
    ),
  );

  getIt.registerFactory<ForgotPasswordCubit>(
    () => ForgotPasswordCubit(
      forgotPasswordUseCase: getIt<ForgotPasswordUseCase>(),
      verifyResetCodeUseCase: getIt<VerifyResetCodeUseCase>(),
      resetPasswordUseCase: getIt<ResetPasswordUseCase>(),
    ),
  );

   getIt.registerLazySingleton<RegisterDataCubit>(
    () => RegisterDataCubit(),
  );



}