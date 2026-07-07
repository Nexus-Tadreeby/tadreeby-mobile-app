import '../../data/models/company_create_request.dart';
import '../../data/models/company_response.dart';
import '../repositories/company_repository.dart';

class CreateCompanyUseCase {
  final CompanyRepository repository;

  CreateCompanyUseCase({required this.repository});

  Future<CompanySingleResponse> execute(CompanyCreateRequest request) {
    return repository.createCompany(request);
  }
}