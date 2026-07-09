import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tadreeby/features/admin/data/models/university_model.dart';
import 'package:tadreeby/features/admin/domain/usecases/activate_university_usecase.dart';
import 'package:tadreeby/features/admin/domain/usecases/deactivate_university_usecase.dart';
import 'package:tadreeby/features/admin/domain/usecases/delete_university_usecase.dart';
import 'package:tadreeby/features/admin/domain/usecases/get_universities_usecase.dart';
import 'package:tadreeby/features/admin/domain/usecases/get_university_by_id_usecase.dart';
import 'university_state.dart';

class UniversityCubit extends Cubit<UniversityState> {
  final GetUniversitiesUseCase getUniversitiesUseCase;
  final GetUniversityByIdUseCase getUniversityByIdUseCase;
  final ActivateUniversityUseCase activateUniversityUseCase;
  final DeactivateUniversityUseCase deactivateUniversityUseCase;
  final DeleteUniversityUseCase deleteUniversityUseCase;

  UniversityCubit({
    required this.getUniversitiesUseCase,
    required this.getUniversityByIdUseCase,
    required this.activateUniversityUseCase,
    required this.deactivateUniversityUseCase,
    required this.deleteUniversityUseCase,
  }) : super(UniversityInitial());

  int _currentPage = 1;
  bool _hasMore = true;
  List<UniversityModel> _allUniversities = [];

  // ✅ متغيرات الإحصائيات
  int _totalCount = 0;
  int _activeCount = 0;
  int _inactiveCount = 0;

  // ✅ أعداد أصلية (بدون فلتر) - تبقى ثابتة
  int _originalTotalCount = 0;
  int _originalActiveCount = 0;
  int _originalInactiveCount = 0;

  Future<void> getUniversities({
    int page = 1,
    int limit = 10,
    String? search,
    bool? isActive,
    String? location,
    String? phone,
    String? sortBy,
    String? sortOrder,
    bool loadMore = false,
  }) async {
    if (loadMore && !_hasMore) return;

    if (!loadMore) {
      _currentPage = 1;
      _hasMore = true;
      _allUniversities = [];
      _totalCount = 0;
      _activeCount = 0;
      _inactiveCount = 0;
      _originalTotalCount = 0;
      _originalActiveCount = 0;
      _originalInactiveCount = 0;
      emit(UniversityLoading());
    }

    try {
      print('📡 Fetching universities with params:');
      print('  page: ${loadMore ? _currentPage + 1 : page}');
      print('  limit: $limit');
      print('  search: $search');
      print('  isActive: $isActive');
      print('  sortBy: $sortBy');
      print('  sortOrder: $sortOrder');

      // ✅ نجلب جميع البيانات (بدون فلتر isActive)
      final response = await getUniversitiesUseCase.execute(
        page: loadMore ? _currentPage + 1 : page,
        limit: limit,
        search: search,
        isActive: null, // ⚠️ لا نرسل فلتر للـ API
        location: location,
        phone: phone,
        sortBy: sortBy,
        sortOrder: sortOrder,
      );

      print('✅ Received ${response.data.length} universities');

      // ✅ نحسب الأعداد الأصلية من جميع البيانات (مرة واحدة فقط)
      if (!loadMore) {
        _originalTotalCount = response.data.length;
        _originalActiveCount = response.data.where((u) => u.isActive).length;
        _originalInactiveCount = response.data.where((u) => !u.isActive).length;
        print('📊 Original counts - Total: $_originalTotalCount, Active: $_originalActiveCount, Inactive: $_originalInactiveCount');
      }

      // ✅ نصفي البيانات للعرض
      List<UniversityModel> filteredData = response.data;
      if (isActive != null) {
        filteredData = filteredData.where((u) => u.isActive == isActive).toList();
        print('📊 Filtered to ${filteredData.length} universities (isActive: $isActive)');
      }

      if (loadMore) {
        _allUniversities.addAll(filteredData);
        _currentPage++;
        _hasMore = response.meta.hasNextPage;
      } else {
        _allUniversities = filteredData;
        _currentPage = response.meta.page;
        _hasMore = response.meta.hasNextPage;
        
        // ✅ استخدم الأعداد الأصلية وليس المصفاة
        _totalCount = _originalTotalCount;
        _activeCount = _originalActiveCount;
        _inactiveCount = _originalInactiveCount;
      }

      print('📊 Display counts - Total: $_totalCount, Active: $_activeCount, Inactive: $_inactiveCount');

      emit(UniversitiesLoaded(
        universities: _allUniversities,
        meta: response.meta,
        hasMore: _hasMore,
        totalCount: _totalCount,
        activeCount: _activeCount,
        inactiveCount: _inactiveCount,
      ));
    } catch (e) {
      print('❌ Error loading universities: $e');
      emit(UniversityError(message: e.toString()));
    }
  }

  Future<void> loadMoreUniversities() async {
    if (_hasMore) {
      await getUniversities(loadMore: true);
    }
  }

  Future<void> getUniversityById(int id) async {
    emit(UniversityLoading());
    try {
      final response = await getUniversityByIdUseCase.execute(id);
      emit(UniversityLoaded(university: response.data));
    } catch (e) {
      emit(UniversityError(message: e.toString()));
    }
  }

  Future<void> activateUniversity(int id) async {
    try {
      await activateUniversityUseCase.execute(id);
      emit(UniversityActionSuccess(message: 'University activated successfully'));
      await getUniversities();
    } catch (e) {
      emit(UniversityError(message: e.toString()));
    }
  }

  Future<void> deactivateUniversity(int id) async {
    try {
      await deactivateUniversityUseCase.execute(id);
      emit(UniversityActionSuccess(message: 'University deactivated successfully'));
      await getUniversities();
    } catch (e) {
      emit(UniversityError(message: e.toString()));
    }
  }

  Future<void> deleteUniversity(int id) async {
    try {
      await deleteUniversityUseCase.execute(id);
      emit(UniversityActionSuccess(message: 'University deleted successfully'));
      await getUniversities();
    } catch (e) {
      emit(UniversityError(message: e.toString()));
    }
  }

  void reset() {
    _currentPage = 1;
    _hasMore = true;
    _allUniversities = [];
    _totalCount = 0;
    _activeCount = 0;
    _inactiveCount = 0;
    _originalTotalCount = 0;
    _originalActiveCount = 0;
    _originalInactiveCount = 0;
    emit(UniversityInitial());
  }
}