class CompanyCreateRequest {
  final String name;
  final String shortCode;
  final String? email;
  final String? phone;
  final String? location;
  final String? description;
  final String? logo;

  CompanyCreateRequest({
    required this.name,
    required this.shortCode,
    this.email,
    this.phone,
    this.location,
    this.description,
    this.logo,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'shortCode': shortCode,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (location != null) 'location': location,
      if (description != null) 'description': description,
      if (logo != null) 'logo': logo,
    };
  }

  factory CompanyCreateRequest.fromJson(Map<String, dynamic> json) {
    return CompanyCreateRequest(
      name: json['name'] as String,
      shortCode: json['shortCode'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      location: json['location'] as String?,
      description: json['description'] as String?,
      logo: json['logo'] as String?,
    );
  }
}