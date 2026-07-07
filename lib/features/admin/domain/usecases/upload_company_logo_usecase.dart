import 'dart:io';
import '../../data/models/company_response.dart';
import '../repositories/company_repository.dart';

class UploadCompanyLogoUseCase {
  final CompanyRepository repository;

  UploadCompanyLogoUseCase({required this.repository});

  Future<CompanyLogoUploadResponse> execute(int id, File file) {
    return repository.uploadCompanyLogo(id, file);
  }
}