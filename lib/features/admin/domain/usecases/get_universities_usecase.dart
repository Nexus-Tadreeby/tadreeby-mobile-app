import '../../data/models/university_response.dart';
import '../repositories/university_repository.dart';

class GetUniversitiesUseCase {
  final UniversityRepository repository;

  GetUniversitiesUseCase({required this.repository});

  Future<UniversityListResponse> execute({
    int page = 1,
    int limit = 10,
    String? search,
    bool? isActive,
    String? location,
    String? phone,
    String? sortBy = 'name',
    String? sortOrder = 'desc',
  }) {
    return repository.getUniversities(
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
}