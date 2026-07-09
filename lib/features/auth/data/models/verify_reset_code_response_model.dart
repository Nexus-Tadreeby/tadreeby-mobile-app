class VerifyResetCodeResponseModel {
  final String resetToken;

  VerifyResetCodeResponseModel({required this.resetToken});

  factory VerifyResetCodeResponseModel.fromJson(Map<String, dynamic> json) {
    return VerifyResetCodeResponseModel(
      resetToken: json['resetToken'] ?? '',
    );
  }
}