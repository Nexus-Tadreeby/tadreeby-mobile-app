import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tadreeby/features/admin/data/models/company_model.dart';
import 'package:tadreeby/features/admin/domain/usecases/activate_company_usecase.dart';
import 'package:tadreeby/features/admin/domain/usecases/deactivate_company_usecase.dart';
import 'package:tadreeby/features/admin/domain/usecases/delete_company_usecase.dart';
import 'package:tadreeby/features/admin/domain/usecases/get_companies_usecase.dart';
import 'package:tadreeby/features/admin/domain/usecases/get_company_by_id_usecase.dart';
import 'company_state.dart';

class CompanyCubit extends Cubit<CompanyState> {
  final GetCompaniesUseCase getCompaniesUseCase;
  final GetCompanyByIdUseCase getCompanyByIdUseCase;
  final ActivateCompanyUseCase activateCompanyUseCase;
  final DeactivateCompanyUseCase deactivateCompanyUseCase;
  final DeleteCompanyUseCase deleteCompanyUseCase;

  CompanyCubit({
    required this.getCompaniesUseCase,
    required this.getCompanyByIdUseCase,
    required this.activateCompanyUseCase,
    required this.deactivateCompanyUseCase,
    required this.deleteCompanyUseCase,
  }) : super(CompanyInitial());

  int _currentPage = 1;
  bool _hasMore = true;
  List<CompanyModel> _allCompanies = [];
  int _totalCount = 0;
  int _activeCount = 0;
  int _inactiveCount = 0;


 int _originalTotalCount = 0;
  int _originalActiveCount = 0;
  int _originalInactiveCount = 0;

  Future<void> getCompanies({
    int page = 1,
    int limit = 10,
    String? search,
    bool? isActive,
    String? location,
    String? phone,
    String sortBy = 'name',
    String sortOrder = 'asc',
    bool loadMore = false,
  }) async {
    if (loadMore && !_hasMore) return;

    if (!loadMore) {
      _currentPage = 1;
      _hasMore = true;
      _allCompanies = [];
      _totalCount = 0;
      _activeCount = 0;
      _inactiveCount = 0;
      _originalTotalCount = 0;
      _originalActiveCount = 0;
      _originalInactiveCount = 0;
      emit(CompanyLoading());
    }

    try {
      print('📡 Fetching companies with params:');
      print('  page: ${loadMore ? _currentPage + 1 : page}');
      print('  limit: $limit');
      print('  search: $search');
      print('  isActive: $isActive');

      final response = await getCompaniesUseCase.execute(
        page: loadMore ? _currentPage + 1 : page,
        limit: limit,
        search: search,
        isActive: null,
        location: location,
        phone: phone,
        sortBy: sortBy,
        sortOrder: sortOrder,
      );

      print('✅ Received ${response.data.length} companies');

      if (!loadMore) {
        _originalTotalCount = response.data.length;
        _originalActiveCount = response.data.where((c) => c.isActive).length;
        _originalInactiveCount = response.data.where((c) => !c.isActive).length;
        print('📊 Original counts - Total: $_originalTotalCount, Active: $_originalActiveCount, Inactive: $_originalInactiveCount');
      }

      List<CompanyModel> filteredData = response.data;
      if (isActive != null) {
        filteredData = filteredData.where((c) => c.isActive == isActive).toList();
        print('📊 Filtered to ${filteredData.length} companies (isActive: $isActive)');
      }

      if (loadMore) {
        _allCompanies.addAll(filteredData);
        _currentPage++;
        _hasMore = response.meta?.hasNextPage ?? false;
      } else {
        _allCompanies = filteredData;
        _currentPage = response.meta?.page ?? 1;
        _hasMore = response.meta?.hasNextPage ?? false;
        
        _totalCount = _originalTotalCount;
        _activeCount = _originalActiveCount;
        _inactiveCount = _originalInactiveCount;
      }

      print('📊 Display counts - Total: $_totalCount, Active: $_activeCount, Inactive: $_inactiveCount');

      emit(CompaniesLoaded(
        companies: _allCompanies,
        meta: response.meta,
        hasMore: _hasMore,
        totalCount: _totalCount,
        activeCount: _activeCount,
        inactiveCount: _inactiveCount,
      ));
    } catch (e) {
      print('❌ Error loading companies: $e');
      emit(CompanyError(message: e.toString()));
    }
  }
  
  Future<void> loadMoreCompanies() async {
    if (_hasMore) {
      await getCompanies(loadMore: true);
    }
  }

  Future<void> getCompanyById(int id) async {
    emit(CompanyLoading());
    try {
      final response = await getCompanyByIdUseCase.execute(id);
      emit(CompanyLoaded(company: response.data));
    } catch (e) {
      emit(CompanyError(message: e.toString()));
    }
  }

  Future<void> activateCompany(int id) async {
    try {
      await activateCompanyUseCase.execute(id);
      emit(CompanyActionSuccess(message: 'Company activated successfully'));
      await getCompanies();
    } catch (e) {
      emit(CompanyError(message: e.toString()));
    }
  }

  Future<void> deactivateCompany(int id) async {
    try {
      await deactivateCompanyUseCase.execute(id);
      emit(CompanyActionSuccess(message: 'Company deactivated successfully'));
      await getCompanies();
    } catch (e) {
      emit(CompanyError(message: e.toString()));
    }
  }

  Future<void> deleteCompany(int id) async {
    try {
      await deleteCompanyUseCase.execute(id);
      emit(CompanyActionSuccess(message: 'Company deleted successfully'));
      await getCompanies();
    } catch (e) {
      emit(CompanyError(message: e.toString()));
    }
  }

  void reset() {
    _currentPage = 1;
    _hasMore = true;
    _allCompanies = [];
    _totalCount = 0;
    _activeCount = 0;
    _inactiveCount = 0;
    emit(CompanyInitial());
  }
}