class UniversityStatistics {
  final int totalUsers;
  final int totalStudents;
  final int totalSupervisors;
  final int totalInternships;
  final UserRoles userRoles;
  final InternshipStatuses internshipStatuses;

  UniversityStatistics({
    required this.totalUsers,
    required this.totalStudents,
    required this.totalSupervisors,
    required this.totalInternships,
    required this.userRoles,
    required this.internshipStatuses,
  });

  factory UniversityStatistics.fromJson(Map<String, dynamic> json) {
    return UniversityStatistics(
      totalUsers: json['totalUsers'] as int? ?? 0,
      totalStudents: json['totalStudents'] as int? ?? 0,
      totalSupervisors: json['totalSupervisors'] as int? ?? 0,
      totalInternships: json['totalInternships'] as int? ?? 0,
      userRoles: UserRoles.fromJson(json['userRoles'] ?? {}),
      internshipStatuses: InternshipStatuses.fromJson(json['internshipStatuses'] ?? {}),
    );
  }
}

class UserRoles {
  final int student;
  final int universitySupervisor;
  final int universityAdmin;

  UserRoles({
    required this.student,
    required this.universitySupervisor,
    required this.universityAdmin,
  });

  factory UserRoles.fromJson(Map<String, dynamic> json) {
    return UserRoles(
      student: json['STUDENT'] as int? ?? 0,
      universitySupervisor: json['UNIVERSITY_SUPERVISOR'] as int? ?? 0,
      universityAdmin: json['UNIVERSITY_ADMIN'] as int? ?? 0,
    );
  }
}

class InternshipStatuses {
  final int active;
  final int completed;
  final int closed;

  InternshipStatuses({
    required this.active,
    required this.completed,
    required this.closed,
  });

  factory InternshipStatuses.fromJson(Map<String, dynamic> json) {
    return InternshipStatuses(
      active: json['ACTIVE'] as int? ?? 0,
      completed: json['COMPLETED'] as int? ?? 0,
      closed: json['CLOSED'] as int? ?? 0,
    );
  }
}