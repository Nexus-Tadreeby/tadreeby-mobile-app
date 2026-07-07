import '../../data/models/company_response.dart';
import '../repositories/company_repository.dart';

class GetCompaniesUseCase {
  final CompanyRepository repository;

  GetCompaniesUseCase({required this.repository});

  Future<CompanyListResponse> execute({
    int page = 1,
    int limit = 10,
    String? search,
    bool? isActive,
    String? location,
    String? phone,
    String sortBy = 'name',
    String sortOrder = 'desc',
  }) {
    return repository.getCompanies(
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