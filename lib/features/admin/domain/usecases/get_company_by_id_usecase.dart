import '../../data/models/company_response.dart';
import '../repositories/company_repository.dart';

class GetCompanyByIdUseCase {
  final CompanyRepository repository;

  GetCompanyByIdUseCase({required this.repository});

  Future<CompanySingleResponse> execute(int id) {
    return repository.getCompanyById(id);
  }
}