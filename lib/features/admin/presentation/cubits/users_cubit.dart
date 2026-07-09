import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tadreeby/features/admin/domain/usecases/get_users_usecase.dart';
import '../../data/models/user_model.dart';
import 'users_state.dart';

class UsersCubit extends Cubit<UsersState> {
  final GetUsersUseCase getUsersUseCase;

  UsersCubit({required this.getUsersUseCase}) : super(UsersInitial());
List<UserModel> _allUsers = [];
  int _currentPage = 1;
  int _totalPages = 1;
  int _totalUsers = 0;
  bool _isLoading = false;
  
  // ✅ حفظ الفلترات الحالية
  String? _currentSearch;
  String? _currentRole;
  bool? _currentIsActive;
  int? _currentUniversityId;
  int? _currentCompanyId;

  Future<void> getUsers({
    int page = 1,
    int limit = 20,
    String? search,
    String? role,
    bool? isActive,
    int? universityId,
    int? companyId,
  }) async {
    // ✅ منع الطلبات المتكررة
    if (_isLoading) return;
    
    _isLoading = true;
      print('🟡 [getUsers] Called with page: $page');
    _currentPage = page;
    _currentSearch = search;
    _currentRole = role;
    _currentIsActive = isActive;
    _currentUniversityId = universityId;
    _currentCompanyId = companyId;
    
    emit(UsersLoading());

    try {
      final response = await getUsersUseCase.execute(
        page: page,
        limit: limit,
        search: search,
        role: role,
        isActive: isActive,
        universityId: universityId,
        companyId: companyId,
      );

      _currentPage = response.meta.page;
      _totalPages = response.meta.totalPages;
      _totalUsers = response.meta.total;

      print('📊 [Cubit] Response data length: ${response.data.length}');
      print('📊 [Cubit] Current page: $_currentPage');
      print('📊 [Cubit] Total pages: $_totalPages');
      print('📊 [Cubit] Total users: $_totalUsers');
      print('📊 [Cubit] Has more: ${response.meta.hasNextPage}');

      emit(UsersLoaded(
        users: response.data,
        total: _totalUsers,
        page: _currentPage,
        totalPages: _totalPages,
        hasMore: response.meta.hasNextPage,
      ));
      print('📊 [UsersLoaded] Displaying ${response.data.length} users on page $_currentPage');
print('📊 [UsersLoaded] Total users in list: ${response.data.length}');
print('📊 [UsersLoaded] Total pages: $_totalPages');
      print('✅ [getUsers] Emitted UsersLoaded with ${response.data.length} users');

    } catch (e) {
            print('❌ [getUsers] Error: $e');

      emit(UsersError(message: e.toString()));
    } finally {
      _isLoading = false;
    }
  }

  // ✅ الانتقال لصفحة معينة
  Future<void> goToPage(int page) async {
    if (_isLoading) return;
    if (page < 1 || page > _totalPages) return;
    if (page == _currentPage) return;
    
    await getUsers(
      page: page,
      limit: 20,
      search: _currentSearch,
      role: _currentRole,
      isActive: _currentIsActive,
      universityId: _currentUniversityId,
      companyId: _currentCompanyId,
    );
  }

  // ✅ الصفحة التالية
  Future<void> nextPage() async {
    if (_currentPage < _totalPages) {
      await goToPage(_currentPage + 1);
    }
  }

  // ✅ الصفحة السابقة
  Future<void> previousPage() async {
    if (_currentPage > 1) {
      await goToPage(_currentPage - 1);
    }
  }

  // ✅ تحديث مع البحث (يعيد للصفحة 1)
  Future<void> searchUsers(String? search) async {
    await getUsers(
      page: 1,
      limit: 20,
      search: search,
      role: _currentRole,
      isActive: _currentIsActive,
      universityId: _currentUniversityId,
      companyId: _currentCompanyId,
    );
  }

  // ✅ تحديث مع الفلتر (يعيد للصفحة 1)
  Future<void> filterUsers({
    String? role,
    bool? isActive,
    int? universityId,
    int? companyId,
  }) async {
    await getUsers(
      page: 1,
      limit: 20,
      search: _currentSearch,
      role: role,
      isActive: isActive,
      universityId: universityId,
      companyId: companyId,
    );
  }

  void reset() {
    _currentPage = 1;
    _totalPages = 1;
    _totalUsers = 0;
    _isLoading = false;
    _currentSearch = null;
    _currentRole = null;
    _currentIsActive = null;
    _currentUniversityId = null;
    _currentCompanyId = null;
    emit(UsersInitial());
  }
  
  bool get isLoading => _isLoading;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  int get totalUsers => _totalUsers;
}