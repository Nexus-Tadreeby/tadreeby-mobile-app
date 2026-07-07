// lib/features/admin/presentation/cubits/university_state.dart
import '../../data/models/university_model.dart';
import '../../data/models/university_response.dart';

abstract class UniversityState {}

class UniversityInitial extends UniversityState {}

class UniversityLoading extends UniversityState {}

class UniversitiesLoaded extends UniversityState {
  final List<UniversityModel> universities;
  final MetaData meta;
  final bool hasMore;
  final int totalCount;
  final int activeCount;
  final int inactiveCount;

  UniversitiesLoaded({
    required this.universities,
    required this.meta,
    this.hasMore = false,
    this.totalCount = 0,
    this.activeCount = 0,
    this.inactiveCount = 0,
  });
}

class UniversityLoaded extends UniversityState {
  final UniversityModel university;

  UniversityLoaded({required this.university});
}

class UniversityStatisticsLoaded extends UniversityState {
  final Map<String, dynamic> statistics;

  UniversityStatisticsLoaded({required this.statistics});
}

class UniversityActionSuccess extends UniversityState {
  final String message;

  UniversityActionSuccess({required this.message});
}

class UniversityError extends UniversityState {
  final String message;

  UniversityError({required this.message});
}