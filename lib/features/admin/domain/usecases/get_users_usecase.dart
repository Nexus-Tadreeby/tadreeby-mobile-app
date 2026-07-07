import '../../data/models/user_model.dart';
import '../repositories/user_repository.dart';

class GetUsersUseCase {
  final UserRepository repository;

  GetUsersUseCase({required this.repository});

  Future<UsersListResponse> execute({
    int page = 1,
    int limit = 20,
    String? search,
    String? role,
    bool? isActive,
    int? universityId,
    int? companyId,
  }) {
    return repository.getUsers(
      page: page,
      limit: limit,
      search: search,
      role: role,
      isActive: isActive,
      universityId: universityId,
      companyId: companyId,
    );
  }
}