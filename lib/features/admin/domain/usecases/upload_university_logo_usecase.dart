import 'dart:io';
import '../../data/models/university_response.dart';
import '../repositories/university_repository.dart';

class UploadUniversityLogoUseCase {
  final UniversityRepository repository;

  UploadUniversityLogoUseCase({required this.repository});

  Future<LogoUploadResponse> execute(int id, File file) {
    return repository.uploadUniversityLogo(id, file);
  }
}