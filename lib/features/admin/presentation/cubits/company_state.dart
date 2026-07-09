// import '../../data/models/company_model.dart';
// import '../../data/models/company_response.dart';

// abstract class CompanyState {}

// class CompanyInitial extends CompanyState {}

// class CompanyLoading extends CompanyState {}

// class CompaniesLoaded extends CompanyState {
//   final List<CompanyModel> companies;
//   final CompanyMetaData meta;
//   final bool hasMore;

//   CompaniesLoaded({
//     required this.companies,
//     required this.meta,
//     this.hasMore = false,
//   });
// }

// class CompanyLoaded extends CompanyState {
//   final CompanyModel company;

//   CompanyLoaded({required this.company});
// }

// class CompanyActionSuccess extends CompanyState {
//   final String message;

//   CompanyActionSuccess({required this.message});
// }

// class CompanyError extends CompanyState {
//   final String message;

//   CompanyError({required this.message});
// }
// lib/features/admin/presentation/cubits/company_state.dart

import '../../data/models/company_model.dart';
import '../../data/models/company_response.dart';

abstract class CompanyState {}

class CompanyInitial extends CompanyState {}

class CompanyLoading extends CompanyState {}

class CompaniesLoaded extends CompanyState {
  final List<CompanyModel> companies;
  final CompanyMetaData? meta;
  final bool hasMore;
  final int totalCount;
  final int activeCount;
  final int inactiveCount;

  CompaniesLoaded({
    required this.companies,
    this.meta,
    this.hasMore = false,
    this.totalCount = 0,
    this.activeCount = 0,
    this.inactiveCount = 0,
  });
}

class CompanyLoaded extends CompanyState {
  final CompanyModel company;

  CompanyLoaded({required this.company});
}

class CompanyActionSuccess extends CompanyState {
  final String message;

  CompanyActionSuccess({required this.message});
}

class CompanyError extends CompanyState {
  final String message;

  CompanyError({required this.message});
}