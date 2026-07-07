class LoginResponseModel {
  final UserModel user;
  final String accessToken;
  final String refreshToken;
  final String sessionId;

  LoginResponseModel({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
    required this.sessionId,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      user: UserModel.fromJson(json['user']),
      accessToken: json['accessToken'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      sessionId: json['sessionId'] ?? '',
    );
  }
}

class UserModel {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final int personalID;
  final String? phone;
  final String? profileImage;
  final String role;
  final int? universityId;
  final int? companyId;
  final bool isActive;
  final String createdAt;
  final String? recoveryEmail;
  final StudentProfileModel? studentProfile;

  UserModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.personalID,
    this.phone,
    this.profileImage,
    required this.role,
    this.universityId,
    this.companyId,
    required this.isActive,
    required this.createdAt,
    this.recoveryEmail,
    this.studentProfile,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      personalID: json['personalID'] ?? 0,
      phone: json['phone'],
      profileImage: json['profileImage'],
      role: json['role'] ?? 'STUDENT',
      universityId: json['universityId'],
      companyId: json['companyId'],
      isActive: json['isActive'] ?? false,
      createdAt: json['createdAt'] ?? '',
      recoveryEmail: json['recoveryEmail'],
      studentProfile: json['studentProfile'] != null 
          ? StudentProfileModel.fromJson(json['studentProfile']) 
          : null,
    );
  }
}

class StudentProfileModel {
  final int userId;
  final int universityId;
  final num studentNumber;
  final String major;
  final int? academicYear;
  final double? gpa;
  final String? cvUrl;
  final String verificationDocument;
  final String approvalStatus;
  final String? approvedAt;
  final String? rejectionReason;

  StudentProfileModel({
    required this.userId,
    required this.universityId,
    required this.studentNumber,
    required this.major,
    this.academicYear,
    this.gpa,
    this.cvUrl,
    required this.verificationDocument,
    required this.approvalStatus,
    this.approvedAt,
    this.rejectionReason,
  });

  factory StudentProfileModel.fromJson(Map<String, dynamic> json) {
    return StudentProfileModel(
      userId: json['userId'] ?? 0,
      universityId: json['universityId'] ?? 0,
      studentNumber: json['studentNumber'] ?? 0,
      major: json['major'] ?? '',
      academicYear: json['academicYear'],
      gpa: json['gpa'] != null ? (json['gpa'] as num).toDouble() : null,
      cvUrl: json['cvUrl'],
      verificationDocument: json['verificationDocument'] ?? '',
      approvalStatus: json['approvalStatus'] ?? 'PENDING',
      approvedAt: json['approvedAt'],
      rejectionReason: json['rejectionReason'],
    );
  }
}