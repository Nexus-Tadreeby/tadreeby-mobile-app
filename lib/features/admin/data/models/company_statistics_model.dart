class CompanyStatistics {
  final int totalUsers;
  final int totalTrainers;
  final int totalInternships;
  final int totalOpportunities;

  CompanyStatistics({
    required this.totalUsers,
    required this.totalTrainers,
    required this.totalInternships,
    required this.totalOpportunities,
  });

  factory CompanyStatistics.fromJson(Map<String, dynamic> json) {
    return CompanyStatistics(
      totalUsers: json['totalUsers'] as int? ?? 0,
      totalTrainers: json['totalTrainers'] as int? ?? 0,
      totalInternships: json['totalInternships'] as int? ?? 0,
      totalOpportunities: json['totalOpportunities'] as int? ?? 0,
    );
  }
}