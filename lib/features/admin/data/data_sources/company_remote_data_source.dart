import 'dart:io';
import 'package:dio/dio.dart';
import 'package:tadreeby/features/admin/data/models/company_statistics_model.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../models/company_create_request.dart';
import '../models/company_update_request.dart';
import '../models/company_response.dart';

abstract class CompanyRemoteDataSource {
  Future<CompanySingleResponse> createCompany(CompanyCreateRequest request);
  Future<CompanyListResponse> getCompanies({
    int page = 1,
    int limit = 10,
    String? search,
    bool? isActive,
    String? location,
    String? phone,
    String sortBy = 'name',
    String sortOrder = 'desc',
  });
  Future<CompanyListResponse> searchCompanies({
    required String query,
    int page = 1,
    int limit = 10,
  });
  Future<CompanySingleResponse> getCompanyById(int id);
  Future<CompanySingleResponse> updateCompany(int id, CompanyUpdateRequest request);
  Future<CompanySingleResponse> activateCompany(int id);
  Future<CompanySingleResponse> deactivateCompany(int id);
  Future<void> deleteCompany(int id);
  Future<CompanyLogoUploadResponse> uploadCompanyLogo(int id, File file);
  Future<void> deleteCompanyLogo(int id);
}

class CompanyRemoteDataSourceImpl implements CompanyRemoteDataSource {
  final Dio _dio;

  CompanyRemoteDataSourceImpl(DioClient dioClient) : _dio = dioClient.dio;

  @override
  Future<CompanySingleResponse> createCompany(CompanyCreateRequest request) async {
    try {
      final response = await _dio.post(
        ApiConstants.companies,
        data: request.toJson(),
      );
      return CompanySingleResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

// @override
// Future<CompanyListResponse> getCompanies({
//   int page = 1,
//   int limit = 10,
//   String? search,
//   bool? isActive,
//   String? location,
//   String? phone,
//   String sortBy = 'name',
//   String sortOrder = 'asc',
// }) async {
//   try {
//     final queryParams = <String, dynamic>{
//       'page': page,
//       'limit': limit,
//       'sortBy': sortBy,
//       'sortOrder': sortOrder,
//     };

//     if (search != null && search.isNotEmpty) {
//       queryParams['search'] = search;
//     }
//     if (isActive != null) {
//       queryParams['isActive'] = isActive;
//     }
//     if (location != null && location.isNotEmpty) {
//       queryParams['location'] = location;
//     }
//     if (phone != null && phone.isNotEmpty) {
//       queryParams['phone'] = phone;
//     }

//     print('📤 GET Companies URL: ${ApiConstants.companies}');
//     print('📤 Query Params: $queryParams');

//     final response = await _dio.get(
//       ApiConstants.companies,
//       queryParameters: queryParams,
//     );

//     print('📥 Response Status: ${response.statusCode}');
//     print('📥 Response Data: ${response.data}');

//     // ✅ تأكد من أن response.data هو Map
//     if (response.data is Map<String, dynamic>) {
//       return CompanyListResponse.fromJson(response.data as Map<String, dynamic>);
//     } else {
//       throw Exception('Invalid response format');
//     }
//   } on DioException catch (e) {
//     print('❌ Dio Error: ${e.response?.statusCode}');
//     print('❌ Response Data: ${e.response?.data}');
//     throw _handleError(e);
//   }
// }


@override
Future<CompanyListResponse> getCompanies({
  int page = 1,
  int limit = 10,
  String? search,
  bool? isActive,
  String? location,
  String? phone,
  String sortBy = 'name',
  String sortOrder = 'asc',
}) async {
  try {
    final queryParams = <String, dynamic>{
      'page': page,
      'limit': limit,
      'sortBy': sortBy,
      'sortOrder': sortOrder,
    };

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

    print('📤 GET Companies URL: ${ApiConstants.companies}');
    print('📤 Query Params: $queryParams');

    final response = await _dio.get(
      ApiConstants.companies,
      queryParameters: queryParams,
    );

    print('📥 Response Status: ${response.statusCode}');
    print('📥 Response Data: ${response.data}');

    // ✅ التحقق من أن response.data هو Map
    if (response.data is Map<String, dynamic>) {
      final Map<String, dynamic> data = response.data as Map<String, dynamic>;
      
      // ✅ التحقق من وجود 'data' في الـ Response
      if (data['data'] != null) {
        return CompanyListResponse.fromJson(data);
      } else {
        // ✅ إذا لم يكن هناك 'data'، نعيد قائمة فارغة
        return CompanyListResponse(
          success: data['success'] as bool? ?? true,
          data: [],
          meta: CompanyMetaData(
            page: 1,
            limit: 0,
            total: 0,
            totalPages: 1,
            hasNextPage: false,
            hasPreviousPage: false,
          ),
        );
      }
    } else {
      // ✅ إذا كان التنسيق غير متوقع
      print('❌ Unexpected response format: ${response.data.runtimeType}');
      throw Exception('Invalid response format from server');
    }
  } on DioException catch (e) {
    print('❌ Dio Error: ${e.response?.statusCode}');
    print('❌ Response Data: ${e.response?.data}');
    throw _handleError(e);
  }
}
Future<CompanyStatistics> getCompanyStatistics(int id) async {
  try {
    final response = await _dio.get('${ApiConstants.companyById(id)}/statistics');
    return CompanyStatistics.fromJson(response.data['data'] ?? {});
  } on DioException catch (e) {
    throw _handleError(e);
  }
}
  @override
  Future<CompanyListResponse> searchCompanies({
    required String query,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await _dio.get(
        '${ApiConstants.companies}/search',
        queryParameters: {
          'q': query,
          'page': page,
          'limit': limit,
        },
      );
      return CompanyListResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<CompanySingleResponse> getCompanyById(int id) async {
    try {
      final response = await _dio.get(ApiConstants.companyById(id));
      return CompanySingleResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<CompanySingleResponse> updateCompany(int id, CompanyUpdateRequest request) async {
    try {
      final response = await _dio.patch(
        ApiConstants.companyById(id),
        data: request.toJson(),
      );
      return CompanySingleResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<CompanySingleResponse> activateCompany(int id) async {
    try {
      final response = await _dio.patch(ApiConstants.companyActivate(id));
      return CompanySingleResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<CompanySingleResponse> deactivateCompany(int id) async {
    try {
      final response = await _dio.patch(ApiConstants.companyDeactivate(id));
      return CompanySingleResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> deleteCompany(int id) async {
    try {
      await _dio.delete(ApiConstants.companyById(id));
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<CompanyLogoUploadResponse> uploadCompanyLogo(int id, File file) async {
    try {
      final fileName = file.path.split('/').last;
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path,
          filename: fileName,
        ),
      });

      final response = await _dio.post(
        ApiConstants.companyLogo(id),
        data: formData,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data'},
        ),
      );
      return CompanyLogoUploadResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> deleteCompanyLogo(int id) async {
    try {
      await _dio.delete(ApiConstants.companyLogo(id));
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
      return 'Company with this name or short code already exists.';
    } else if (statusCode == 404) {
      return 'Company not found.';
    } else if (statusCode == 403) {
      return 'You do not have permission to perform this action.';
    } else if (statusCode == 401) {
      return 'Your session has expired. Please login again.';
    }

    return e.message ?? 'An error occurred';
  }
}