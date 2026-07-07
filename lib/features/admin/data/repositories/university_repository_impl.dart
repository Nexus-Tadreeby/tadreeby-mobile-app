// lib/features/admin/data/repositories/university_repository_impl.dart
import 'dart:io';
import '../../domain/repositories/university_repository.dart';
import '../data_sources/university_remote_data_source.dart';
import '../models/university_create_request.dart';
import '../models/university_update_request.dart';
import '../models/university_response.dart';
import '../models/university_statistics_model.dart';

class UniversityRepositoryImpl implements UniversityRepository {
  final UniversityRemoteDataSource remoteDataSource;

  UniversityRepositoryImpl({required this.remoteDataSource});

  @override
  Future<UniversitySingleResponse> createUniversity(UniversityCreateRequest request) {
    return remoteDataSource.createUniversity(request);
  }

  @override
  Future<UniversityListResponse> getUniversities({
    int page = 1,
    int limit = 10,
    String? search,
    bool? isActive,
    String? location,
    String? phone,
    String? sortBy = 'name',
    String? sortOrder = 'desc',
  }) {
    return remoteDataSource.getUniversities(
      page: page,
      limit: limit,
      search: search,
      isActive: isActive,
      location: location,
      phone: phone,
      sortBy: sortBy,
      sortOrder: sortOrder,
    );
  }

  @override
  Future<UniversityListResponse> searchUniversities({
    required String query,
    int page = 1,
    int limit = 10,
  }) {
    return remoteDataSource.searchUniversities(
      query: query,
      page: page,
      limit: limit,
    );
  }

  @override
  Future<UniversitySingleResponse> getUniversityById(int id) {
    return remoteDataSource.getUniversityById(id);
  }

  @override
  Future<UniversitySingleResponse> updateUniversity(int id, UniversityUpdateRequest request) {
    return remoteDataSource.updateUniversity(id, request);
  }

  @override
  Future<UniversitySingleResponse> activateUniversity(int id) {
    return remoteDataSource.activateUniversity(id);
  }

  @override
  Future<UniversitySingleResponse> deactivateUniversity(int id) {
    return remoteDataSource.deactivateUniversity(id);
  }

  @override
  Future<void> deleteUniversity(int id) {
    return remoteDataSource.deleteUniversity(id);
  }

  @override
  Future<LogoUploadResponse> uploadUniversityLogo(int id, File file) {
    return remoteDataSource.uploadUniversityLogo(id, file);
  }

  @override
  Future<void> deleteUniversityLogo(int id) {
    return remoteDataSource.deleteUniversityLogo(id);
  }

  @override
  Future<UniversityStatistics> getUniversityStatistics(int id) {
    return remoteDataSource.getUniversityStatistics(id);
  }
}