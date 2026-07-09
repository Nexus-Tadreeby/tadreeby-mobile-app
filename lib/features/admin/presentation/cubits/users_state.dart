import '../../data/models/user_model.dart';

abstract class UsersState {}

class UsersInitial extends UsersState {}

class UsersLoading extends UsersState {}

class UsersLoaded extends UsersState {
  final List<UserModel> users;
  final int total;
  final int page;
  final int totalPages;
  final bool hasMore;

  UsersLoaded({
    required this.users,
    required this.total,
    required this.page,
    required this.totalPages,
    this.hasMore = false,
  });
}

class UsersLoadingMore extends UsersState {
  final List<UserModel> currentUsers;
  
  UsersLoadingMore({required this.currentUsers});
}

class UsersError extends UsersState {
  final String message;

  UsersError({required this.message});
}