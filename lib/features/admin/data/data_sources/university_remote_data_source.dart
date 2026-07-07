import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../models/university_create_request.dart';
import '../models/university_update_request.dart';
import '../models/university_response.dart';
import '../models/university_statistics_model.dart';

abstract class UniversityRemoteDataSource {
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

class UniversityRemoteDataSourceImpl implements UniversityRemoteDataSource {
  final Dio _dio;

  UniversityRemoteDataSourceImpl(DioClient dioClient) : _dio = dioClient.dio;

  @override
  Future<UniversitySingleResponse> createUniversity(UniversityCreateRequest request) async {
    try {
      final response = await _dio.post(
 ApiConstants.createUniversity,
         data: request.toJson(),
      );
      return UniversitySingleResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
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
    String? sortOrder = 'asc',
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
        // 'sortBy': sortBy,
        // 'sortOrder': sortOrder,
      };
    if (sortBy != null && sortBy.isNotEmpty) {
      queryParams['sortBy'] = sortBy;
    }
    if (sortOrder != null && sortOrder.isNotEmpty) {
      queryParams['sortOrder'] = sortOrder;
    }
      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }
      if (isActive != null) {
        queryParams['isActive'] = isActive;
      }
      if (location != null && location.isNotEmpty) {
        queryParams['location'] = location;
      }
      if (phone != null && phone.isNotEmpty) {
        queryParams['phone'] = phone;
      }

      print('📤 GET Universities URL: ${ApiConstants.universities}');
      print('📤 Query Params: $queryParams');

      final response = await _dio.get(
        ApiConstants.universities,
        queryParameters: queryParams,
      );

      print('📥 Response Status: ${response.statusCode}');
      print('📥 Response Data: ${response.data}');

      return UniversityListResponse.fromJson(response.data);
    } on DioException catch (e) {
      print('❌ Dio Error: ${e.response?.statusCode}');
      print('❌ Response Data: ${e.response?.data}');
      throw _handleError(e);
    }
  }


  @override
  Future<UniversityListResponse> searchUniversities({
    required String query,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await _dio.get(
        ApiConstants.universitySearch,
        queryParameters: {
          'q': query,
          'page': page,
          'limit': limit,
        },
      );
      return UniversityListResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<UniversitySingleResponse> getUniversityById(int id) async {
    try {
      final response = await _dio.get(ApiConstants.universityById(id));
      return UniversitySingleResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<UniversitySingleResponse> updateUniversity(int id, UniversityUpdateRequest request) async {
    try {
      final response = await _dio.patch(
        ApiConstants.universityById(id),
        data: request.toJson(),
      );
      return UniversitySingleResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<UniversitySingleResponse> activateUniversity(int id) async {
    try {
      final response = await _dio.patch(ApiConstants.universityActivate(id));
      return UniversitySingleResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<UniversitySingleResponse> deactivateUniversity(int id) async {
    try {
      final response = await _dio.patch(ApiConstants.universityDeactivate(id));
      return UniversitySingleResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> deleteUniversity(int id) async {
    try {
      await _dio.delete(ApiConstants.universityById(id));
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<LogoUploadResponse> uploadUniversityLogo(int id, File file) async {
    try {
      final fileName = file.path.split('/').last;
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path,
          filename: fileName,
        ),
      });

      final response = await _dio.post(
        ApiConstants.universityLogo(id),
        data: formData,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data'},
        ),
      );
      return LogoUploadResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> deleteUniversityLogo(int id) async {
    try {
      await _dio.delete(ApiConstants.universityLogo(id));
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<UniversityStatistics> getUniversityStatistics(int id) async {
    try {
      final response = await _dio.get(ApiConstants.universityStatistics(id));
      return UniversityStatistics.fromJson(response.data['data'] ?? {});
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

    String _handleError(DioException e) {
    final statusCode = e.response?.statusCode;
    final data = e.response?.data;

    if (data is Map<String, dynamic>) {
      final message = data['message'] ?? 'An error occurred';
      final fields = data['fields'] as List?;

      if (fields != null && fields.isNotEmpty) {
        final fieldErrors = fields.map((f) {
          return '${f['field']}: ${f['message']}';
        }).join('\n');
        return '$message\n$fieldErrors';
      }

      return message;
    }

    if (statusCode == 409) {
      return 'University with this name or short code already exists.';
    } else if (statusCode == 404) {
      return 'University not found.';
    } else if (statusCode == 403) {
      return 'You do not have permission to perform this action.';
    } else if (statusCode == 401) {
      return 'Your session has expired. Please login again.';
    }

    return e.message ?? 'An error occurred';
  }
}