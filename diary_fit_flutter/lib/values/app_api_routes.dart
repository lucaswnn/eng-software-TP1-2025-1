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

  static const String backendAccessTokenLabel = 'access';
  static const String backendRefreshTokenLabel = 'refresh';
  static const String backendUserTypeLabel = 'tipo';

  static const String backendWeightUsernameLabel = 'usuario_username';
  static const String backendWeightDateLabel = 'data';
  static const String backendWeightValueLabel = 'peso';

  static const String backendAnamnesisUsernameLabel = 'usuario_username';
  static const String backendAnamnesisAgeLabel = 'idade';
  static const String backendAnamnesisHeightLabel = 'altura_cm';
  static const String backendAnamnesisWeightLabel = 'peso_inicial';
  static const String backendAnamnesisAllergiesLabel = 'alergias';
  static const String backendAnamnesisGoalLabel = 'objetivo';

  static const String backendRelationshipProfessionalLabel = 'profissional_username';
  static const String backendRelationshipPatientLabel = 'paciente_username';
  static const String backendRelationshipProfessionalTypeLabel = 'tipo_profissional';
}
