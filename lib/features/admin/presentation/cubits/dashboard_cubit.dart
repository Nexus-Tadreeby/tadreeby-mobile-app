// lib/features/admin/presentation/cubits/dashboard_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tadreeby/features/admin/domain/usecases/get_companies_usecase.dart';
import 'package:tadreeby/features/admin/domain/usecases/get_universities_usecase.dart';
import 'package:tadreeby/features/admin/domain/usecases/get_users_usecase.dart';

// ─── States ──────────────────────────────────────────────────────
abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final int universitiesCount;
  final int companiesCount;
  final int usersCount;
  final String universitiesTrend;
  final String companiesTrend;
  final String usersTrend;

  DashboardLoaded({
    required this.universitiesCount,
    required this.companiesCount,
    required this.usersCount,
    required this.universitiesTrend,
    required this.companiesTrend,
    required this.usersTrend,
  });
}

class DashboardError extends DashboardState {
  final String message;

  DashboardError({required this.message});
}

// ─── Cubit ──────────────────────────────────────────────────────
class DashboardCubit extends Cubit<DashboardState> {
  final GetUniversitiesUseCase getUniversitiesUseCase;
  final GetCompaniesUseCase getCompaniesUseCase;
  final GetUsersUseCase getUsersUseCase;

  DashboardCubit({
    required this.getUniversitiesUseCase,
    required this.getCompaniesUseCase,
    required this.getUsersUseCase,
  }) : super(DashboardInitial());

  // متغيرات لحساب النسب
  int _previousUniversitiesCount = 0;
  int _previousCompaniesCount = 0;
  int _previousUsersCount = 0;

  Future<void> loadDashboardData() async {
    emit(DashboardLoading());

    try {
      // ─── جلب إحصائيات المستخدمين ──────────────────────────────
      final usersResponse = await getUsersUseCase.execute(
        limit: 1,
        page: 1,
      );

      // ─── جلب الجامعات ──────────────────────────────────────────
      final universitiesResponse = await getUniversitiesUseCase.execute(
        limit: 1,
        page: 1,
      );

      // ─── جلب الشركات ──────────────────────────────────────────
      final companiesResponse = await getCompaniesUseCase.execute(
        limit: 1,
        page: 1,
      );

      // ─── حساب الأعداد ────────────────────────────────────────────
      final universitiesCount = universitiesResponse.meta.total;
      final companiesCount = companiesResponse.meta?.total ?? 0;
      final usersCount = usersResponse.meta.total;

      // ─── حساب النسب ────────────────────────────────────────────
      final universitiesTrend = _calculateTrend(
        _previousUniversitiesCount,
        universitiesCount,
      );
      final companiesTrend = _calculateTrend(
        _previousCompaniesCount,
        companiesCount,
      );
      final usersTrend = _calculateTrend(
        _previousUsersCount,
        usersCount,
      );

      // ─── حفظ القيم الحالية للمقارنة القادمة ──────────────────
      _previousUniversitiesCount = universitiesCount;
      _previousCompaniesCount = companiesCount;
      _previousUsersCount = usersCount;

      emit(DashboardLoaded(
        universitiesCount: universitiesCount,
        companiesCount: companiesCount,
        usersCount: usersCount,
        universitiesTrend: universitiesTrend,
        companiesTrend: companiesTrend,
        usersTrend: usersTrend,
      ));
    } catch (e) {
      emit(DashboardError(message: e.toString()));
    }
  }

  // ─── حساب النسبة المئوية ──────────────────────────────────────
  String _calculateTrend(int previous, int current) {
    if (previous == 0) {
      return current > 0 ? '+100%' : '0%';
    }
    final difference = current - previous;
    final percentage = (difference / previous) * 100;
    if (percentage > 0) {
      return '+${percentage.toStringAsFixed(0)}%';
    } else if (percentage < 0) {
      return '${percentage.toStringAsFixed(0)}%';
    } else {
      return '0%';
    }
  }
}