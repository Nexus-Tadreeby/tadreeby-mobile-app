class UserStatistics {
  final int totalUsers;
  final int activeUsers;
  final int inactiveUsers;
  final List<RoleDistribution> roleDistribution;
  final List<UniversityDistribution> universityDistribution;
  final List<CompanyDistribution> companyDistribution;

  UserStatistics({
    required this.totalUsers,
    required this.activeUsers,
    required this.inactiveUsers,
    required this.roleDistribution,
    required this.universityDistribution,
    required this.companyDistribution,
  });

  factory UserStatistics.fromJson(Map<String, dynamic> json) {
    return UserStatistics(
      totalUsers: json['totalUsers'] as int? ?? 0,
      activeUsers: json['activeUsers'] as int? ?? 0,
      inactiveUsers: json['inactiveUsers'] as int? ?? 0,
      roleDistribution: (json['roleDistribution'] as List?)
          ?.map((e) => RoleDistribution.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      universityDistribution: (json['universityDistribution'] as List?)
          ?.map((e) => UniversityDistribution.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      companyDistribution: (json['companyDistribution'] as List?)
          ?.map((e) => CompanyDistribution.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
    );
  }
}

class RoleDistribution {
  final String role;
  final int count;

  RoleDistribution({
    required this.role,
    required this.count,
  });

  factory RoleDistribution.fromJson(Map<String, dynamic> json) {
    return RoleDistribution(
      role: json['role'] as String? ?? '',
      count: json['count'] as int? ?? 0,
    );
  }
}

class UniversityDistribution {
  final int universityId;
  final String universityName;
  final int count;

  UniversityDistribution({
    required this.universityId,
    required this.universityName,
    required this.count,
  });

  factory UniversityDistribution.fromJson(Map<String, dynamic> json) {
    return UniversityDistribution(
      universityId: json['universityId'] as int? ?? 0,
      universityName: json['universityName'] as String? ?? '',
      count: json['count'] as int? ?? 0,
    );
  }
}

class CompanyDistribution {
  final int companyId;
  final String companyName;
  final int count;

  CompanyDistribution({
    required this.companyId,
    required this.companyName,
    required this.count,
  });

  factory CompanyDistribution.fromJson(Map<String, dynamic> json) {
    return CompanyDistribution(
      companyId: json['companyId'] as int? ?? 0,
      companyName: json['companyName'] as String? ?? '',
      count: json['count'] as int? ?? 0,
    );
  }
}