import 'dart:io';
import '../../domain/repositories/company_repository.dart';
import '../data_sources/company_remote_data_source.dart';
import '../models/company_create_request.dart';
import '../models/company_update_request.dart';
import '../models/company_response.dart';

class CompanyRepositoryImpl implements CompanyRepository {
  final CompanyRemoteDataSource remoteDataSource;

  CompanyRepositoryImpl({required this.remoteDataSource});

  @override
  Future<CompanySingleResponse> createCompany(CompanyCreateRequest request) {
    return remoteDataSource.createCompany(request);
  }

  @override
  Future<CompanyListResponse> getCompanies({
    int page = 1,
    int limit = 10,
    String? search,
    bool? isActive,
    String? location,
    String? phone,
    String sortBy = 'name',
    String sortOrder = 'desc',
  }) {
    return remoteDataSource.getCompanies(
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

  @override
  Future<CompanyListResponse> searchCompanies({
    required String query,
    int page = 1,
    int limit = 10,
  }) {
    return remoteDataSource.searchCompanies(
      query: query,
      page: page,
      limit: limit,
    );
  }

  @override
  Future<CompanySingleResponse> getCompanyById(int id) {
    return remoteDataSource.getCompanyById(id);
  }

  @override
  Future<CompanySingleResponse> updateCompany(int id, CompanyUpdateRequest request) {
    return remoteDataSource.updateCompany(id, request);
  }

  @override
  Future<CompanySingleResponse> activateCompany(int id) {
    return remoteDataSource.activateCompany(id);
  }

  @override
  Future<CompanySingleResponse> deactivateCompany(int id) {
    return remoteDataSource.deactivateCompany(id);
  }

  @override
  Future<void> deleteCompany(int id) {
    return remoteDataSource.deleteCompany(id);
  }

  @override
  Future<CompanyLogoUploadResponse> uploadCompanyLogo(int id, File file) {
    return remoteDataSource.uploadCompanyLogo(id, file);
  }

  @override
  Future<void> deleteCompanyLogo(int id) {
    return remoteDataSource.deleteCompanyLogo(id);
  }
}