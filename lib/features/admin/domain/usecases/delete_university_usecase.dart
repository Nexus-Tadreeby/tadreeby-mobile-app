import '../repositories/university_repository.dart';

class DeleteUniversityUseCase {
  final UniversityRepository repository;

  DeleteUniversityUseCase({required this.repository});

  Future<void> execute(int id) {
    return repository.deleteUniversity(id);
  }
}