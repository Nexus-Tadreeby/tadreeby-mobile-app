class UniversityModel {
  final int id;
  final String name;
  final String shortCode;
  final String? email;
  final String? phone;
  final String? location;
  final String? description;
  final String? logo;
  final bool isActive;
  final String createdAt;
  final String updatedAt;
  final UniversityCount? count;

  UniversityModel({
    required this.id,
    required this.name,
    required this.shortCode,
    this.email,
    this.phone,
    this.location,
    this.description,
    this.logo,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.count,
  });

  factory UniversityModel.fromJson(Map<String, dynamic> json) {
    return UniversityModel(
      id: json['id'] as int,
      name: json['name'] as String,
      shortCode: json['shortCode'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      location: json['location'] as String?,
      description: json['description'] as String?,
      logo: json['logo'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      count: json['_count'] != null
          ? UniversityCount.fromJson(json['_count'])
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
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      if (count != null) '_count': count!.toJson(),
    };
  }

  UniversityModel copyWith({
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
    UniversityCount? count,
  }) {
    return UniversityModel(
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
    );
  }
}

class UniversityCount {
  final int users;
  final int students;
  final int supervisors;
  final int internships;

  UniversityCount({
    required this.users,
    required this.students,
    required this.supervisors,
    required this.internships,
  });

  factory UniversityCount.fromJson(Map<String, dynamic> json) {
    return UniversityCount(
      users: json['users'] as int? ?? 0,
      students: json['students'] as int? ?? 0,
      supervisors: json['supervisors'] as int? ?? 0,
      internships: json['internships'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'users': users,
      'students': students,
      'supervisors': supervisors,
      'internships': internships,
    };
  }
}