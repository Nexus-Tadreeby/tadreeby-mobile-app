import 'package:get_it/get_it.dart';
import 'package:tadreeby/core/network/dio_client.dart';
import 'package:tadreeby/core/utils/secure_storage_service.dart';
import 'package:tadreeby/features/admin/domain/usecases/get_user_statistics_usecase.dart';
// ─── Auth ─────────────────────────────────────────────────────────
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

// ─── Admin (Universities) ────────────────────────────────────────
import 'package:tadreeby/features/admin/presentation/cubits/dashboard_cubit.dart';
import 'package:tadreeby/features/admin/data/data_sources/university_remote_data_source.dart';
import 'package:tadreeby/features/admin/data/repositories/university_repository_impl.dart';
import 'package:tadreeby/features/admin/domain/repositories/university_repository.dart';
import 'package:tadreeby/features/admin/domain/usecases/create_university_usecase.dart';
import 'package:tadreeby/features/admin/domain/usecases/get_universities_usecase.dart';
import 'package:tadreeby/features/admin/domain/usecases/get_university_by_id_usecase.dart';
import 'package:tadreeby/features/admin/domain/usecases/update_university_usecase.dart';
import 'package:tadreeby/features/admin/domain/usecases/activate_university_usecase.dart';
import 'package:tadreeby/features/admin/domain/usecases/deactivate_university_usecase.dart';
import 'package:tadreeby/features/admin/domain/usecases/delete_university_usecase.dart';
import 'package:tadreeby/features/admin/domain/usecases/upload_university_logo_usecase.dart';
import 'package:tadreeby/features/admin/presentation/cubits/university_cubit.dart';
import 'package:tadreeby/features/admin/presentation/cubits/create_university_cubit.dart';

// ─── Admin (Companies) ──────────────────────────────────────────
import 'package:tadreeby/features/admin/data/data_sources/company_remote_data_source.dart';
import 'package:tadreeby/features/admin/data/repositories/company_repository_impl.dart';
import 'package:tadreeby/features/admin/domain/repositories/company_repository.dart';
import 'package:tadreeby/features/admin/domain/usecases/create_company_usecase.dart';
import 'package:tadreeby/features/admin/domain/usecases/get_companies_usecase.dart';
import 'package:tadreeby/features/admin/domain/usecases/get_company_by_id_usecase.dart';
import 'package:tadreeby/features/admin/domain/usecases/update_company_usecase.dart';
import 'package:tadreeby/features/admin/domain/usecases/activate_company_usecase.dart';
import 'package:tadreeby/features/admin/domain/usecases/deactivate_company_usecase.dart';
import 'package:tadreeby/features/admin/domain/usecases/delete_company_usecase.dart';
import 'package:tadreeby/features/admin/domain/usecases/upload_company_logo_usecase.dart';
import 'package:tadreeby/features/admin/presentation/cubits/company_cubit.dart';
import 'package:tadreeby/features/admin/presentation/cubits/create_company_cubit.dart';


// ─── Users ──────────────────────────────────────────────────────
import 'package:tadreeby/features/admin/data/data_sources/user_remote_data_source.dart';
import 'package:tadreeby/features/admin/data/repositories/user_repository_impl.dart';
import 'package:tadreeby/features/admin/domain/repositories/user_repository.dart';
import 'package:tadreeby/features/admin/domain/usecases/get_users_usecase.dart';
import 'package:tadreeby/features/admin/presentation/cubits/users_cubit.dart';

final GetIt getIt = GetIt.instance;

void setupLocator() {
  // ─── Core Services ──────────────────────────────────────────
  getIt.registerLazySingleton<SecureStorageService>(
    () => SecureStorageService(),
  );

  getIt.registerLazySingleton<DioClient>(
    () => DioClient(),
  );

  // ─── Auth Remote Data Source ───────────────────────────────
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      getIt<DioClient>(),
    ),
  );

  // ─── Auth Repository ────────────────────────────────────────
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt<AuthRemoteDataSource>(),
    ),
  );

  // ─── Auth Use Cases ──────────────────────────────────────────
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

  // ─── Auth Cubits ─────────────────────────────────────────────
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

  // ─────────────────────────────────────────────────────────────
  // ─── UNIVERSITY MODULE ──────────────────────────────────────
  // ─────────────────────────────────────────────────────────────

  // ─── University Remote Data Source ──────────────────────────
  getIt.registerLazySingleton<UniversityRemoteDataSource>(
    () => UniversityRemoteDataSourceImpl(
      getIt<DioClient>(),
    ),
  );

  // ─── University Repository ──────────────────────────────────
  getIt.registerLazySingleton<UniversityRepository>(
    () => UniversityRepositoryImpl(
      remoteDataSource: getIt<UniversityRemoteDataSource>(),
    ),
  );

  // ─── University Use Cases ────────────────────────────────────
  getIt.registerLazySingleton<CreateUniversityUseCase>(
    () => CreateUniversityUseCase(
      repository: getIt<UniversityRepository>(),
    ),
  );

  getIt.registerLazySingleton<GetUniversitiesUseCase>(
    () => GetUniversitiesUseCase(
      repository: getIt<UniversityRepository>(),
    ),
  );

  getIt.registerLazySingleton<GetUniversityByIdUseCase>(
    () => GetUniversityByIdUseCase(
      repository: getIt<UniversityRepository>(),
    ),
  );

  getIt.registerLazySingleton<UpdateUniversityUseCase>(
    () => UpdateUniversityUseCase(
      repository: getIt<UniversityRepository>(),
    ),
  );

  getIt.registerLazySingleton<ActivateUniversityUseCase>(
    () => ActivateUniversityUseCase(
      repository: getIt<UniversityRepository>(),
    ),
  );

  getIt.registerLazySingleton<DeactivateUniversityUseCase>(
    () => DeactivateUniversityUseCase(
      repository: getIt<UniversityRepository>(),
    ),
  );

  getIt.registerLazySingleton<DeleteUniversityUseCase>(
    () => DeleteUniversityUseCase(
      repository: getIt<UniversityRepository>(),
    ),
  );

  getIt.registerLazySingleton<UploadUniversityLogoUseCase>(
    () => UploadUniversityLogoUseCase(
      repository: getIt<UniversityRepository>(),
    ),
  );

  // ─── University Cubits ───────────────────────────────────────
  getIt.registerFactory<UniversityCubit>(
    () => UniversityCubit(
      getUniversitiesUseCase: getIt<GetUniversitiesUseCase>(),
      getUniversityByIdUseCase: getIt<GetUniversityByIdUseCase>(),
      activateUniversityUseCase: getIt<ActivateUniversityUseCase>(),
      deactivateUniversityUseCase: getIt<DeactivateUniversityUseCase>(),
      deleteUniversityUseCase: getIt<DeleteUniversityUseCase>(),
    ),
  );

  getIt.registerFactory<CreateUniversityCubit>(
    () => CreateUniversityCubit(
      createUniversityUseCase: getIt<CreateUniversityUseCase>(),
      uploadUniversityLogoUseCase: getIt<UploadUniversityLogoUseCase>(),
    ),
  );

  // ─────────────────────────────────────────────────────────────
  // ─── COMPANY MODULE ────────────────────────────────────────
  // ─────────────────────────────────────────────────────────────

  getIt.registerLazySingleton<CompanyRemoteDataSource>(
    () => CompanyRemoteDataSourceImpl(
      getIt<DioClient>(),
    ),
  );

  getIt.registerLazySingleton<CompanyRepository>(
    () => CompanyRepositoryImpl(
      remoteDataSource: getIt<CompanyRemoteDataSource>(),
    ),
  );

  getIt.registerLazySingleton<CreateCompanyUseCase>(
    () => CreateCompanyUseCase(
      repository: getIt<CompanyRepository>(),
    ),
  );

  getIt.registerLazySingleton<GetCompaniesUseCase>(
    () => GetCompaniesUseCase(
      repository: getIt<CompanyRepository>(),
    ),
  );

  getIt.registerLazySingleton<GetCompanyByIdUseCase>(
    () => GetCompanyByIdUseCase(
      repository: getIt<CompanyRepository>(),
    ),
  );

  getIt.registerLazySingleton<UpdateCompanyUseCase>(
    () => UpdateCompanyUseCase(
      repository: getIt<CompanyRepository>(),
    ),
  );

  getIt.registerLazySingleton<ActivateCompanyUseCase>(
    () => ActivateCompanyUseCase(
      repository: getIt<CompanyRepository>(),
    ),
  );

  getIt.registerLazySingleton<DeactivateCompanyUseCase>(
    () => DeactivateCompanyUseCase(
      repository: getIt<CompanyRepository>(),
    ),
  );

  getIt.registerLazySingleton<DeleteCompanyUseCase>(
    () => DeleteCompanyUseCase(
      repository: getIt<CompanyRepository>(),
    ),
  );

  getIt.registerLazySingleton<UploadCompanyLogoUseCase>(
    () => UploadCompanyLogoUseCase(
      repository: getIt<CompanyRepository>(),
    ),
  );

  getIt.registerFactory<CompanyCubit>(
    () => CompanyCubit(
      getCompaniesUseCase: getIt<GetCompaniesUseCase>(),
      getCompanyByIdUseCase: getIt<GetCompanyByIdUseCase>(),
      activateCompanyUseCase: getIt<ActivateCompanyUseCase>(),
      deactivateCompanyUseCase: getIt<DeactivateCompanyUseCase>(),
      deleteCompanyUseCase: getIt<DeleteCompanyUseCase>(),
    ),
  );

  getIt.registerFactory<CreateCompanyCubit>(
    () => CreateCompanyCubit(
      createCompanyUseCase: getIt<CreateCompanyUseCase>(),
      uploadCompanyLogoUseCase: getIt<UploadCompanyLogoUseCase>(),
    ),
  );


  // ─── Users Remote Data Source ────────────────────────────────
getIt.registerLazySingleton<UserRemoteDataSource>(
  () => UserRemoteDataSourceImpl(
    getIt<DioClient>(),
  ),
);

// ─── Users Repository ────────────────────────────────────────
getIt.registerLazySingleton<UserRepository>(
  () => UserRepositoryImpl(
    remoteDataSource: getIt<UserRemoteDataSource>(),
  ),
);

// ─── Users Use Cases ──────────────────────────────────────────
getIt.registerLazySingleton<GetUsersUseCase>(
  () => GetUsersUseCase(
    repository: getIt<UserRepository>(),
  ),
);

// ─── Users Cubit ─────────────────────────────────────────────
getIt.registerFactory<UsersCubit>(
  () => UsersCubit(
    getUsersUseCase: getIt<GetUsersUseCase>(),
  ),
);
getIt.registerFactory<DashboardCubit>(
  () => DashboardCubit(
    getUniversitiesUseCase: getIt<GetUniversitiesUseCase>(),
    getCompaniesUseCase: getIt<GetCompaniesUseCase>(),
    getUsersUseCase: getIt<GetUsersUseCase>(),
  ),
);
getIt.registerLazySingleton<GetUserStatisticsUseCase>(
  () => GetUserStatisticsUseCase(
    repository: getIt<UserRepository>(),
  ),
);
}