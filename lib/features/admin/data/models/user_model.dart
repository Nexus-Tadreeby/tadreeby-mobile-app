// ============================================================
// 📦 User Model
// ============================================================
class UserModel {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String? recoveryEmail;
  final String? phone;
  final String role;
  final bool isActive;
  final int? universityId;
  final int? companyId;
  final String? profileImage;
  final String? createdAt;
  final String? updatedAt;
  final UniversityBrief? university;
  final CompanyBrief? company;
  final StudentProfileBrief? studentProfile;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.recoveryEmail,
    this.phone,
    required this.role,
    required this.isActive,
    this.universityId,
    this.companyId,
    this.profileImage,
    this.createdAt,
    this.updatedAt,
    this.university,
    this.company,
    this.studentProfile,
  });

  String get fullName => '$firstName $lastName';
  String get initials => '${firstName[0]}${lastName[0]}';

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      recoveryEmail: json['recoveryEmail']?.toString(),
      phone: json['phone']?.toString(),
      role: json['role'] as String,
      isActive: json['isActive'] as bool? ?? true,
      universityId: json['universityId'] as int?,
      companyId: json['companyId'] as int?,
      profileImage: json['profileImage']?.toString(),
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
      university: json['university'] != null
          ? UniversityBrief.fromJson(json['university'] as Map<String, dynamic>)
          : null,
      company: json['company'] != null
          ? CompanyBrief.fromJson(json['company'] as Map<String, dynamic>)
          : null,
      studentProfile: json['studentProfile'] != null
          ? StudentProfileBrief.fromJson(json['studentProfile'] as Map<String, dynamic>)
          : null,
    );
  }
}

// ============================================================
// 📦 University Brief
// ============================================================
class UniversityBrief {
  final int id;
  final String name;
  final String shortCode;

  UniversityBrief({
    required this.id,
    required this.name,
    required this.shortCode,
  });

  factory UniversityBrief.fromJson(Map<String, dynamic> json) {
    return UniversityBrief(
      id: json['id'] as int,
      name: json['name'] as String,
      shortCode: json['shortCode'] as String,
    );
  }
}

// ============================================================
// 📦 Company Brief
// ============================================================
class CompanyBrief {
  final int id;
  final String name;
  final String shortCode;

  CompanyBrief({
    required this.id,
    required this.name,
    required this.shortCode,
  });

  factory CompanyBrief.fromJson(Map<String, dynamic> json) {
    return CompanyBrief(
      id: json['id'] as int,
      name: json['name'] as String,
      shortCode: json['shortCode'] as String,
    );
  }
}

// ============================================================
// 📦 Student Profile Brief
// ============================================================
class StudentProfileBrief {
  final String major;
  final int studentNumber;
  final String approvalStatus;

  StudentProfileBrief({
    required this.major,
    required this.studentNumber,
    required this.approvalStatus,
  });

  factory StudentProfileBrief.fromJson(Map<String, dynamic> json) {
    return StudentProfileBrief(
      major: json['major'] as String,
      studentNumber: json['studentNumber'] as int,
      approvalStatus: json['approvalStatus'] as String,
    );
  }
}

// ============================================================
// 📦 Users Meta Data
// ============================================================
class UsersMetaData {
  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPreviousPage;

  UsersMetaData({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  factory UsersMetaData.fromJson(Map<String, dynamic> json) {
    return UsersMetaData(
      page: json['page'] as int? ?? 1,
      limit: json['limit'] as int? ?? 20,
      total: json['total'] as int? ?? 0,
      totalPages: json['totalPages'] as int? ?? 0,
      hasNextPage: json['hasNextPage'] as bool? ?? false,
      hasPreviousPage: json['hasPreviousPage'] as bool? ?? false,
    );
  }
}

// ============================================================
// 📦 Users List Response ✅ هذا هو المطلوب
// ============================================================
class UsersListResponse {
  final bool success;
  final List<UserModel> data;
  final UsersMetaData meta;

  UsersListResponse({
    required this.success,
    required this.data,
    required this.meta,
  });

  factory UsersListResponse.fromJson(Map<String, dynamic> json) {
    return UsersListResponse(
      success: json['success'] as bool? ?? true,
      data: (json['data'] as List?)
          ?.map((e) => UserModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
      meta: UsersMetaData.fromJson(json['meta'] ?? {}),
    );
  }
}