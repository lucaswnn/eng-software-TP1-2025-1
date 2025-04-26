class AppApiRequests {
  AppApiRequests._(); // Private constructor to prevent instantiation

  static const String baseUrl = 'http://127.0.0.1:8000';
  static const String login = '$baseUrl/api/token/';
  static const String register = '$baseUrl/api/signup/';
  static const String getUserProfile = '$baseUrl/user/profile';
  static const String updateUserProfile = '$baseUrl/user/update';
  static const String getDiaryEntries = '$baseUrl/diary/entries';
  static const String addDiaryEntry = '$baseUrl/diary/add';
  static const String updateDiaryEntry = '$baseUrl/diary/update';
  static const String deleteDiaryEntry = '$baseUrl/diary/delete';

  static const String backendPatientType = 'paciente';
  static const String backendTrainerType = 'educador_fisico';
  static const String backendNutritionistType = 'nutricionista';

  static const String backendAccessToken = 'access';
  static const String backendRefreshToken = 'refresh';
}
