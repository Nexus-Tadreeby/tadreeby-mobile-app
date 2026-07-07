import 'dart:io';
import '../../data/models/company_create_request.dart';
import '../../data/models/company_update_request.dart';
import '../../data/models/company_response.dart';

abstract class CompanyRepository {
  Future<CompanySingleResponse> createCompany(CompanyCreateRequest request);
  Future<CompanyListResponse> getCompanies({
    int page = 1,
    int limit = 10,
    String? search,
    bool? isActive,
    String? location,
    String? phone,
    String sortBy = 'name',
    String sortOrder = 'desc',
  });
  Future<CompanyListResponse> searchCompanies({
    required String query,
    int page = 1,
    int limit = 10,
  });
  Future<CompanySingleResponse> getCompanyById(int id);
  Future<CompanySingleResponse> updateCompany(int id, CompanyUpdateRequest request);
  Future<CompanySingleResponse> activateCompany(int id);
  Future<CompanySingleResponse> deactivateCompany(int id);
  Future<void> deleteCompany(int id);
  Future<CompanyLogoUploadResponse> uploadCompanyLogo(int id, File file);
  Future<void> deleteCompanyLogo(int id);
}