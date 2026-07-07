import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tadreeby/features/admin/data/models/university_create_request.dart';
import 'package:tadreeby/features/admin/data/models/university_response.dart';
import 'package:tadreeby/features/admin/domain/usecases/create_university_usecase.dart';
import 'package:tadreeby/features/admin/domain/usecases/upload_university_logo_usecase.dart';

// ─── States ──────────────────────────────────────────────────────
abstract class CreateUniversityState {}

class CreateUniversityInitial extends CreateUniversityState {}

class CreateUniversityLoading extends CreateUniversityState {}

class CreateUniversitySuccess extends CreateUniversityState {
  final String message;
  final UniversitySingleResponse? university;

  CreateUniversitySuccess({required this.message, this.university});
}

class CreateUniversityError extends CreateUniversityState {
  final String message;
  CreateUniversityError({required this.message});
}

class LogoUploadSuccess extends CreateUniversityState {
  final String url;
  LogoUploadSuccess({required this.url});
}

class LogoUploadError extends CreateUniversityState {
  final String message;
  LogoUploadError({required this.message});
}

class LogoUploadLoading extends CreateUniversityState {}

// ─── Cubit ──────────────────────────────────────────────────────
class CreateUniversityCubit extends Cubit<CreateUniversityState> {
  final CreateUniversityUseCase createUniversityUseCase;
  final UploadUniversityLogoUseCase uploadUniversityLogoUseCase;

  CreateUniversityCubit({
    required this.createUniversityUseCase,
    required this.uploadUniversityLogoUseCase,
  }) : super(CreateUniversityInitial());

  String? _uploadedLogoUrl;
  File? _logoFile;

  Future<void> createUniversity({
    required String name,
    required String shortCode,
    String? email,
    String? phone,
    String? location,
    String? description,
  }) async {
    emit(CreateUniversityLoading());

    try {
      // 1️⃣ Create university first
      final request = UniversityCreateRequest(
        name: name,
        shortCode: shortCode,
        email: email,
        phone: phone,
        location: location,
        description: description,
        logo: null, // No logo yet
      );

      final response = await createUniversityUseCase.execute(request);
      final universityId = response.data.id;

      // 2️⃣ Upload logo if exists
      String? finalLogoUrl;
      if (_logoFile != null) {
        try {
          final logoResponse = await uploadUniversityLogoUseCase.execute(
            universityId,
            _logoFile!,
          );
          finalLogoUrl = logoResponse.data.url;
          emit(LogoUploadSuccess(url: finalLogoUrl));
        } catch (e) {
          // Logo upload failed but university was created
          print('⚠️ Logo upload failed: $e');
        }
      }

      emit(CreateUniversitySuccess(
        message: 'University created successfully!',
        university: response,
      ));
    } catch (e) {
      emit(CreateUniversityError(message: e.toString()));
    }
  }

  Future<void> setLogoFile(File file) async {
    _logoFile = file;
    emit(LogoUploadSuccess(url: file.path)); // Just show preview
  }

  File? get logoFile => _logoFile;

  void reset() {
    _uploadedLogoUrl = null;
    _logoFile = null;
    emit(CreateUniversityInitial());
  }
}