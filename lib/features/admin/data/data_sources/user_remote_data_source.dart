import 'package:dio/dio.dart';
import 'package:tadreeby/features/admin/data/models/user_statistics_model.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../models/user_model.dart';

abstract class UserRemoteDataSource {
  Future<UsersListResponse> getUsers({
    int page = 1,
    int limit = 20,
    String? search,
    String? role,
    bool? isActive,
    int? universityId,
    int? companyId,
  });

  // ✅ أضف هذه الدالة
  Future<UserStatistics> getUserStatistics();
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final Dio _dio;

  UserRemoteDataSourceImpl(DioClient dioClient) : _dio = dioClient.dio;

  @override
  Future<UsersListResponse> getUsers({
    int page = 1,
    int limit = 20,
    String? search,
    String? role,
    bool? isActive,
    int? universityId,
    int? companyId,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
      };

      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }
      if (role != null && role.isNotEmpty) {
        queryParams['role'] = role;
      }
      if (isActive != null) {
        queryParams['isActive'] = isActive;
      }
      if (universityId != null) {
        queryParams['universityId'] = universityId;
      }
      if (companyId != null) {
        queryParams['companyId'] = companyId;
      }

      print('📤 GET Users URL: ${ApiConstants.baseUrl}/users/all');
      print('📤 Page: $page, Limit: $limit');
      print('📤 Query Params: $queryParams');

      final response = await _dio.get(
        ApiConstants.users,
        queryParameters: queryParams,
      );
      
      print('📥 Response Status: ${response.statusCode}');
      print('📥 Response Data: ${response.data}');

      if (response.data is Map<String, dynamic>) {
        final result = UsersListResponse.fromJson(response.data as Map<String, dynamic>);
        print('📥 Users loaded: ${result.data.length} users from page $page');
        print('📥 Total users: ${result.meta.total}, Total pages: ${result.meta.totalPages}');
        return result;
      } else {
        throw Exception('Invalid response format');
      }
    } on DioException catch (e) {
      print('❌ Dio Error: ${e.response?.statusCode}');
      print('❌ Response Data: ${e.response?.data}');
      throw _handleError(e);
    }
  }

  @override
  Future<UserStatistics> getUserStatistics() async {
    try {
      final response = await _dio.get('${ApiConstants.baseUrl}/users/statistics');
      print('📊 User Statistics Response: ${response.data}');
      
      // التأكد من وجود 'data' في الـ Response
      if (response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        if (data['data'] != null) {
          return UserStatistics.fromJson(data['data'] as Map<String, dynamic>);
        }
      }
      
      // إذا لم توجد 'data'، نعيد إحصائيات فارغة
      return UserStatistics(
        totalUsers: 0,
        activeUsers: 0,
        inactiveUsers: 0,
        roleDistribution: [],
        universityDistribution: [],
        companyDistribution: [],
      );
    } on DioException catch (e) {
      print('❌ Error fetching user statistics: ${e.response?.data}');
      throw _handleError(e);
    }
  }

  String _handleError(DioException e) {
    final statusCode = e.response?.statusCode;
    final data = e.response?.data;

    if (data is Map<String, dynamic>) {
      final message = data['message'] ?? 'An error occurred';
      return message;
    }

    if (statusCode == 401) {
      return 'Your session has expired. Please login again.';
    } else if (statusCode == 403) {
      return 'You do not have permission to perform this action.';
    }

    return e.message ?? 'An error occurred';
  }
}