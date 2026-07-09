import '../../data/models/university_response.dart';
import '../repositories/university_repository.dart';

class DeactivateUniversityUseCase {
  final UniversityRepository repository;

  DeactivateUniversityUseCase({required this.repository});

  Future<UniversitySingleResponse> execute(int id) {
    return repository.deactivateUniversity(id);
  }
}