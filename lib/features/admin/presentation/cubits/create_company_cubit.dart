import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tadreeby/features/admin/data/models/company_create_request.dart';
import 'package:tadreeby/features/admin/data/models/company_response.dart';
import 'package:tadreeby/features/admin/domain/usecases/create_company_usecase.dart';
import 'package:tadreeby/features/admin/domain/usecases/upload_company_logo_usecase.dart';

abstract class CreateCompanyState {}

class CreateCompanyInitial extends CreateCompanyState {}

class CreateCompanyLoading extends CreateCompanyState {}

class CreateCompanySuccess extends CreateCompanyState {
  final String message;
  final CompanySingleResponse? company;

  CreateCompanySuccess({required this.message, this.company});
}

class CreateCompanyError extends CreateCompanyState {
  final String message;
  CreateCompanyError({required this.message});
}

class CompanyLogoUploadSuccess extends CreateCompanyState {
  final String url;
  CompanyLogoUploadSuccess({required this.url});
}

class CompanyLogoUploadError extends CreateCompanyState {
  final String message;
  CompanyLogoUploadError({required this.message});
}

class CompanyLogoUploadLoading extends CreateCompanyState {}

class CreateCompanyCubit extends Cubit<CreateCompanyState> {
  final CreateCompanyUseCase createCompanyUseCase;
  final UploadCompanyLogoUseCase uploadCompanyLogoUseCase;

  CreateCompanyCubit({
    required this.createCompanyUseCase,
    required this.uploadCompanyLogoUseCase,
  }) : super(CreateCompanyInitial());

  File? _logoFile;

  Future<void> createCompany({
    required String name,
    required String shortCode,
    String? email,
    String? phone,
    String? location,
    String? description,
  }) async {
    emit(CreateCompanyLoading());

    try {
      final request = CompanyCreateRequest(
        name: name,
        shortCode: shortCode,
        email: email,
        phone: phone,
        location: location,
        description: description,
        logo: null,
      );

      final response = await createCompanyUseCase.execute(request);
      final companyId = response.data.id;

      String? finalLogoUrl;
      if (_logoFile != null) {
        try {
          final logoResponse = await uploadCompanyLogoUseCase.execute(
            companyId,
            _logoFile!,
          );
          finalLogoUrl = logoResponse.data.url;
          emit(CompanyLogoUploadSuccess(url: finalLogoUrl!));
        } catch (e) {
          print('⚠️ Logo upload failed: $e');
        }
      }

      emit(CreateCompanySuccess(
        message: 'Company created successfully!',
        company: response,
      ));
    } catch (e) {
      emit(CreateCompanyError(message: e.toString()));
    }
  }

  Future<void> setLogoFile(File file) async {
    _logoFile = file;
    emit(CompanyLogoUploadSuccess(url: file.path));
  }

  File? get logoFile => _logoFile;

  void reset() {
    _logoFile = null;
    emit(CreateCompanyInitial());
  }
}