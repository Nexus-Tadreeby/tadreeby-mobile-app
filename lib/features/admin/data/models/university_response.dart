import 'university_model.dart';

class UniversityListResponse {
  final bool success;
  final List<UniversityModel> data;
  final MetaData meta;

  UniversityListResponse({
    required this.success,
    required this.data,
    required this.meta,
  });

  factory UniversityListResponse.fromJson(Map<String, dynamic> json) {
    return UniversityListResponse(
      success: json['success'] as bool? ?? true,
      data: (json['data'] as List?)
          ?.map((e) => UniversityModel.fromJson(e))
          .toList() ??
          [],
      meta: MetaData.fromJson(json['meta'] ?? {}),
    );
  }
}

class UniversitySingleResponse {
  final bool success;
  final UniversityModel data;

  UniversitySingleResponse({
    required this.success,
    required this.data,
  });

  factory UniversitySingleResponse.fromJson(Map<String, dynamic> json) {
    return UniversitySingleResponse(
      success: json['success'] as bool? ?? true,
      data: UniversityModel.fromJson(json['data']),
    );
  }
}

class MetaData {
  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPreviousPage;

  MetaData({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  factory MetaData.fromJson(Map<String, dynamic> json) {
    return MetaData(
      page: json['page'] as int? ?? 1,
      limit: json['limit'] as int? ?? 10,
      total: json['total'] as int? ?? 0,
      totalPages: json['totalPages'] as int? ?? 0,
      hasNextPage: json['hasNextPage'] as bool? ?? false,
      hasPreviousPage: json['hasPreviousPage'] as bool? ?? false,
    );
  }
}

class LogoUploadResponse {
  final bool success;
  final LogoData data;

  LogoUploadResponse({
    required this.success,
    required this.data,
  });

  factory LogoUploadResponse.fromJson(Map<String, dynamic> json) {
    return LogoUploadResponse(
      success: json['success'] as bool? ?? true,
      data: LogoData.fromJson(json['data'] ?? {}),
    );
  }
}

class LogoData {
  final String filename;
  final String url;

  LogoData({
    required this.filename,
    required this.url,
  });

  factory LogoData.fromJson(Map<String, dynamic> json) {
    return LogoData(
      filename: json['filename'] as String? ?? '',
      url: json['url'] as String? ?? '',
    );
  }
}