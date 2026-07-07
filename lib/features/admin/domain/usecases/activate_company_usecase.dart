import '../../data/models/company_response.dart';
import '../repositories/company_repository.dart';

class ActivateCompanyUseCase {
  final CompanyRepository repository;

  ActivateCompanyUseCase({required this.repository});

  Future<CompanySingleResponse> execute(int id) {
    return repository.activateCompany(id);
  }
}