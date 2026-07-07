import '../../data/models/university_update_request.dart';
import '../../data/models/university_response.dart';
import '../repositories/university_repository.dart';

class UpdateUniversityUseCase {
  final UniversityRepository repository;

  UpdateUniversityUseCase({required this.repository});

  Future<UniversitySingleResponse> execute(int id, UniversityUpdateRequest request) {
    return repository.updateUniversity(id, request);
  }
}