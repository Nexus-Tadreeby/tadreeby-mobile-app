class ApiConstants {
static const String baseUrl = 'https://tadreeby-backend-production.up.railway.app';

  // ─── Auth ────────────────────────────────────────────────────
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

  // ─── Universities ────────────────────────────────────────────
 static const String universities = '$baseUrl/universities';
   static String universityById(int id) => '$baseUrl/universities/$id';
  static String universityActivate(int id) => '$baseUrl/universities/$id/activate';
  static String universityDeactivate(int id) => '$baseUrl/universities/$id/deactivate';
  static String universityLogo(int id) => '$baseUrl/universities/$id/logo';
  static String universitySearch = '$baseUrl/universities/search';
  static String universityStatistics(int id) => '$baseUrl/universities/$id/statistics';
  static const String createUniversity = '$baseUrl/universities/create-university'; 
  // ─── Companies ──────────────────────────────────────────────
  static const String companies = '$baseUrl/companies';
  static String companyById(int id) => '$baseUrl/companies/$id';
  static String companyActivate(int id) => '$baseUrl/companies/$id/activate';
  static String companyDeactivate(int id) => '$baseUrl/companies/$id/deactivate';
  static String companyLogo(int id) => '$baseUrl/companies/$id/logo';
  static String companySearch = '$baseUrl/companies/search';


  // ─── Users ──────────────────────────────────────────────────────
static const String users = '$baseUrl/users/all';
}
