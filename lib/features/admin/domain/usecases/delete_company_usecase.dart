import '../repositories/company_repository.dart';

class DeleteCompanyUseCase {
  final CompanyRepository repository;

  DeleteCompanyUseCase({required this.repository});

  Future<void> execute(int id) {
    return repository.deleteCompany(id);
  }
}