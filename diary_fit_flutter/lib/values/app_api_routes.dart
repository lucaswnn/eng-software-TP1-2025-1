class AppApiRoutes {
  AppApiRoutes._(); // Private constructor to prevent instantiation

  static const String baseUrl = 'http://127.0.0.1:8000';
  static const String login = '$baseUrl/api/token/';
  static const String register = '$baseUrl/api/signup/';
  static const String calendarData = '$baseUrl/api/calendario/';
  static const String weightData = '$baseUrl/api/pesos/';
  static const String mealData = '$baseUrl/api/refeicoes/';
  static const String exerciseData = '$baseUrl/api/exercicios/';
  static const String anamnesisData = '$baseUrl/api/anamnese/';
  static const String foodData = '$baseUrl/api/alimentos/';
  static const String foodMenuData = '$baseUrl/api/cardapios/';
  static const String relationshipData = '$baseUrl/api/vinculos/';
  static const String workoutSheetData = '$baseUrl/api/fichas/';

  static const String backendPatientType = 'paciente';
  static const String backendTrainerType = 'educador_fisico';
  static const String backendNutritionistType = 'nutricionista';

  static const String backendAccessToken = 'access';
  static const String backendRefreshToken = 'refresh';
}
