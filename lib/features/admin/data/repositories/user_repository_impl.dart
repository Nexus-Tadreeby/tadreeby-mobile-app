import 'package:tadreeby/features/admin/data/models/user_statistics_model.dart';

import '../../domain/repositories/user_repository.dart';
import '../data_sources/user_remote_data_source.dart';
import '../models/user_model.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<UsersListResponse> getUsers({
    int page = 1,
    int limit = 20,
    String? search,
    String? role,
    bool? isActive,
    int? universityId,
    int? companyId,
  }) {
    return remoteDataSource.getUsers(
      page: page,
      limit: limit,
      search: search,
      role: role,
      isActive: isActive,
      universityId: universityId,
      companyId: companyId,
    );
  }
    @override
  Future<UserStatistics> getUserStatistics() {
    return remoteDataSource.getUserStatistics();
  }
}