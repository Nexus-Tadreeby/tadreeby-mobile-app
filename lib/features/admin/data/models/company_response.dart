import 'company_model.dart';

class CompanyListResponse {
  final bool success;
  final List<CompanyModel> data;
  final CompanyMetaData? meta;

  CompanyListResponse({
    required this.success,
    required this.data,
    this.meta,
  });

  factory CompanyListResponse.fromJson(Map<String, dynamic> json) {
    final dataList = json['data'] as List? ?? [];
    
    CompanyMetaData? metaData;
    if (json['meta'] != null) {
      metaData = CompanyMetaData.fromJson(json['meta'] as Map<String, dynamic>);
    } else {
      metaData = CompanyMetaData(
        page: 1,
        limit: dataList.length,
        total: dataList.length,
        totalPages: 1,
        hasNextPage: false,
        hasPreviousPage: false,
      );
    }

    return CompanyListResponse(
      success: json['success'] as bool? ?? true,
      data: dataList
          .map((e) => CompanyModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: metaData,
    );
  }
}

class CompanySingleResponse {
  final bool success;
  final CompanyModel data;

  CompanySingleResponse({
    required this.success,
    required this.data,
  });

  factory CompanySingleResponse.fromJson(Map<String, dynamic> json) {
    return CompanySingleResponse(
      success: json['success'] as bool? ?? true,
      data: CompanyModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

class CompanyMetaData {
  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPreviousPage;

  CompanyMetaData({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  factory CompanyMetaData.fromJson(Map<String, dynamic> json) {
    return CompanyMetaData(
      page: json['page'] as int? ?? 1,
      limit: json['limit'] as int? ?? 10,
      total: json['total'] as int? ?? 0,
      totalPages: json['totalPages'] as int? ?? 0,
      hasNextPage: json['hasNextPage'] as bool? ?? false,
      hasPreviousPage: json['hasPreviousPage'] as bool? ?? false,
    );
  }
}

class CompanyLogoUploadResponse {
  final bool success;
  final CompanyLogoData data;

  CompanyLogoUploadResponse({
    required this.success,
    required this.data,
  });

  factory CompanyLogoUploadResponse.fromJson(Map<String, dynamic> json) {
    return CompanyLogoUploadResponse(
      success: json['success'] as bool? ?? true,
      data: CompanyLogoData.fromJson(json['data'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class CompanyLogoData {
  final String filename;
  final String url;

  CompanyLogoData({
    required this.filename,
    required this.url,
  });

  factory CompanyLogoData.fromJson(Map<String, dynamic> json) {
    return CompanyLogoData(
      filename: json['filename'] as String? ?? '',
      url: json['url'] as String? ?? '',
    );
  }
}