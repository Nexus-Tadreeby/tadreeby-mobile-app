
import 'package:tadreeby/features/admin/data/models/user_statistics_model.dart';

import '../../data/models/user_model.dart';

abstract class UserRepository {
  Future<UsersListResponse> getUsers({
    int page = 1,
    int limit = 20,
    String? search,
    String? role,
    bool? isActive,
    int? universityId,
    int? companyId,
  });
    Future<UserStatistics> getUserStatistics();

}