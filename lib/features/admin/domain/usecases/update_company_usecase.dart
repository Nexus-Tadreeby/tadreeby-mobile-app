import '../../data/models/company_update_request.dart';
import '../../data/models/company_response.dart';
import '../repositories/company_repository.dart';

class UpdateCompanyUseCase {
  final CompanyRepository repository;

  UpdateCompanyUseCase({required this.repository});

  Future<CompanySingleResponse> execute(int id, CompanyUpdateRequest request) {
    return repository.updateCompany(id, request);
  }
}