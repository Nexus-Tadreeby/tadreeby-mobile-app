class UniversityUpdateRequest {
  final String? name;
  final String? shortCode;
  final String? email;
  final String? phone;
  final String? location;
  final String? description;
  final String? logo;
  final bool? isActive;

  UniversityUpdateRequest({
    this.name,
    this.shortCode,
    this.email,
    this.phone,
    this.location,
    this.description,
    this.logo,
    this.isActive,
  });

  Map<String, dynamic> toJson() {
    return {
      if (name != null) 'name': name,
      if (shortCode != null) 'shortCode': shortCode,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (location != null) 'location': location,
      if (description != null) 'description': description,
      if (logo != null) 'logo': logo,
      if (isActive != null) 'isActive': isActive,
    };
  }
}