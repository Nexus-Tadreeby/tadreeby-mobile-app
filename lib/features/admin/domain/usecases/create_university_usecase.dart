import '../../data/models/university_create_request.dart';
import '../../data/models/university_response.dart';
import '../repositories/university_repository.dart';

class CreateUniversityUseCase {
  final UniversityRepository repository;

  CreateUniversityUseCase({required this.repository});

  Future<UniversitySingleResponse> execute(UniversityCreateRequest request) {
    return repository.createUniversity(request);
  }
}