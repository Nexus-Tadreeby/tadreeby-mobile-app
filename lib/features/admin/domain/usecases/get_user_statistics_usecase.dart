import '../../data/models/user_statistics_model.dart';
import '../repositories/user_repository.dart';

class GetUserStatisticsUseCase {
  final UserRepository repository;

  GetUserStatisticsUseCase({required this.repository});

  Future<UserStatistics> execute() {
    return repository.getUserStatistics();
  }
}