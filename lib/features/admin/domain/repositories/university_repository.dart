import '../../data/models/university_create_request.dart';
import '../../data/models/university_update_request.dart';
import '../../data/models/university_response.dart';
import '../../data/models/university_statistics_model.dart';
import 'dart:io';

abstract class UniversityRepository {
  Future<UniversitySingleResponse> createUniversity(UniversityCreateRequest request);
  Future<UniversityListResponse> getUniversities({
    int page = 1,
    int limit = 10,
    String? search,
    bool? isActive,
    String? location,
    String? phone,
    String? sortBy = 'name',
    String? sortOrder = 'desc',
  });
  Future<UniversityListResponse> searchUniversities({
    required String query,
    int page = 1,
    int limit = 10,
  });
  Future<UniversitySingleResponse> getUniversityById(int id);
  Future<UniversitySingleResponse> updateUniversity(int id, UniversityUpdateRequest request);
  Future<UniversitySingleResponse> activateUniversity(int id);
  Future<UniversitySingleResponse> deactivateUniversity(int id);
  Future<void> deleteUniversity(int id);
  Future<LogoUploadResponse> uploadUniversityLogo(int id, File file);
  Future<void> deleteUniversityLogo(int id);
  Future<UniversityStatistics> getUniversityStatistics(int id);
}