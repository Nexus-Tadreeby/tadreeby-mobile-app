class ApiConstants {
static const String baseUrl = 'https://tadreeby-backend-production.up.railway.app';

  static const String registerStudent = '$baseUrl/auth/register/student';
  static const String login = '$baseUrl/auth/login';
  static const String refresh = '$baseUrl/auth/refresh';
  static const String logout = '$baseUrl/auth/logout';
  
  static const String sessions = '$baseUrl/auth/sessions';
  static const String revokeAllSessions = '$baseUrl/auth/sessions/revoke-all';
  static String revokeSessionById(String id) => '$baseUrl/auth/sessions/$id';

  static const String forgotPassword = '$baseUrl/auth/forgot-password';
  static const String verifyResetCode = '$baseUrl/auth/verify-reset-code';
  static const String resetPassword = '$baseUrl/auth/reset-password';
}