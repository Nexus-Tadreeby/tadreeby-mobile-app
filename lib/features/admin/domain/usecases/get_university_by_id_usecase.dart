import '../../data/models/university_response.dart';
import '../repositories/university_repository.dart';

class GetUniversityByIdUseCase {
  final UniversityRepository repository;

  GetUniversityByIdUseCase({required this.repository});

  Future<UniversitySingleResponse> execute(int id) {
    return repository.getUniversityById(id);
  }
}