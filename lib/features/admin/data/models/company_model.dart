class CompanyModel {
  final int id;
  final String name;
  final String shortCode;
  final String? email;
  final String? phone;
  final String? location;
  final String? description;
  final String? logo;
  final bool isActive;
  final String? createdAt;
  final String? updatedAt;
  final CompanyCount? count;
  final String? createdBy;
  final String? updatedBy;

  CompanyModel({
    required this.id,
    required this.name,
    required this.shortCode,
    this.email,
    this.phone,
    this.location,
    this.description,
    this.logo,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
    this.count,
    this.createdBy,
    this.updatedBy,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      id: json['id'] as int,
      name: json['name'] as String,
      shortCode: json['shortCode'] as String,
      email: json['email']?.toString(),
      phone: json['phone']?.toString(),
      location: json['location']?.toString(),
      description: json['description']?.toString(),
      logo: json['logo']?.toString(),
      isActive: json['isActive'] as bool? ?? true,
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
      createdBy: json['createdBy']?.toString(),
      updatedBy: json['updatedBy']?.toString(),
      count: json['_count'] != null
          ? CompanyCount.fromJson(json['_count'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'shortCode': shortCode,
      'email': email,
      'phone': phone,
      'location': location,
      'description': description,
      'logo': logo,
      'isActive': isActive,
      if (createdAt != null) 'createdAt': createdAt,
      if (updatedAt != null) 'updatedAt': updatedAt,
      if (createdBy != null) 'createdBy': createdBy,
      if (updatedBy != null) 'updatedBy': updatedBy,
      if (count != null) '_count': count!.toJson(),
    };
  }

  CompanyModel copyWith({
    int? id,
    String? name,
    String? shortCode,
    String? email,
    String? phone,
    String? location,
    String? description,
    String? logo,
    bool? isActive,
    String? createdAt,
    String? updatedAt,
    CompanyCount? count,
    String? createdBy,
    String? updatedBy,
  }) {
    return CompanyModel(
      id: id ?? this.id,
      name: name ?? this.name,
      shortCode: shortCode ?? this.shortCode,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      description: description ?? this.description,
      logo: logo ?? this.logo,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      count: count ?? this.count,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
    );
  }
}

class CompanyCount {
  final int users;        // عدد المستخدمين (ادمن)
  final int trainers;     // عدد المدربين
  final int internships;  // عدد التدريبات
  final int opportunities; // عدد الفرص
  final int students;     // عدد الطلاب

  CompanyCount({
    required this.users,
    required this.trainers,
    required this.internships,
    required this.opportunities,
    this.students = 0,
  });

  factory CompanyCount.fromJson(Map<String, dynamic> json) {
    return CompanyCount(
      users: json['users'] as int? ?? 0,
      trainers: json['trainers'] as int? ?? 0,
      internships: json['internships'] as int? ?? 0,
      opportunities: json['opportunities'] as int? ?? 0,
      students: json['students'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'users': users,
      'trainers': trainers,
      'internships': internships,
      'opportunities': opportunities,
      'students': students,
    };
  }
}