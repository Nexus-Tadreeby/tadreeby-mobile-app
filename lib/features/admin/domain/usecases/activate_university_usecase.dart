import '../../data/models/university_response.dart';
import '../repositories/university_repository.dart';

class ActivateUniversityUseCase {
  final UniversityRepository repository;

  ActivateUniversityUseCase({required this.repository});

  Future<UniversitySingleResponse> execute(int id) {
    return repository.activateUniversity(id);
  }
}