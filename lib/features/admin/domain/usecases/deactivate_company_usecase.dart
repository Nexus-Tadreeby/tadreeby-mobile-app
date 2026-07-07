import '../../data/models/company_response.dart';
import '../repositories/company_repository.dart';

class DeactivateCompanyUseCase {
  final CompanyRepository repository;

  DeactivateCompanyUseCase({required this.repository});

  Future<CompanySingleResponse> execute(int id) {
    return repository.deactivateCompany(id);
  }
}