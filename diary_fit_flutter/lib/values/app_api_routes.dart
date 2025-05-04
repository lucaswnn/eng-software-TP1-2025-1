// Class that centralizes the backend patterns
class AppApiRoutes {
  AppApiRoutes._(); // Private constructor to prevent instantiation

  // API routes
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

  // Backend user types
  static const String backendPatientType = 'paciente';
  static const String backendTrainerType = 'educador_fisico';
  static const String backendNutritionistType = 'nutricionista';

  // Backend login labels
  static const String backendAccessTokenLabel = 'access';
  static const String backendRefreshTokenLabel = 'refresh';
  static const String backendUserTypeLabel = 'tipo';

  // Backend exercise labels
  static const String backendExerciseUsernameLabel = 'usuario_username';
  static const String backendExerciseDescriptionLabel = 'descricao';
  static const String backendExerciseDateLabel = 'data';

  // Backend meal labels
  static const String backendMealUsernameLabel = 'usuario_username';
  static const String backendMealDescriptionLabel = 'descricao';
  static const String backendMealDateLabel = 'data';

  // Backend food menu labels
  static const String backendFoodMenuUsernameLabel = 'paciente_username';
  static const String backendFoodMenuDescriptionLabel = 'descricao';
  static const String backendFoodMenuStartLabel = 'data_inicio';
  static const String backendFoodMenuEndLabel = 'data_fim';

  // Backend workout sheet labels
  static const String backendWorkoutSheetUsernameLabel = 'usuario_username';
  static const String backendWorkoutSheetDescriptionLabel = 'descricao';
  static const String backendWorkoutSheetStartLabel = 'data_inicio';
  static const String backendWorkoutSheetEndLabel = 'data_fim';

  // Backend weight serializer labels
  static const String backendWeightUsernameLabel = 'usuario_username';
  static const String backendWeightDateLabel = 'data';
  static const String backendWeightValueLabel = 'peso';

  // Backend anamnesis serializer labels
  static const String backendAnamnesisUsernameLabel = 'usuario_username';
  static const String backendAnamnesisAgeLabel = 'idade';
  static const String backendAnamnesisHeightLabel = 'altura_cm';
  static const String backendAnamnesisWeightLabel = 'peso_inicial';
  static const String backendAnamnesisAllergiesLabel = 'alergias';
  static const String backendAnamnesisGoalLabel = 'objetivo';

  // Backend relationship serializer labels
  static const String backendRelationshipProfessionalLabel = 'profissional_username';
  static const String backendRelationshipPatientLabel = 'paciente_username';
  static const String backendRelationshipProfessionalTypeLabel = 'tipo_profissional';
}
