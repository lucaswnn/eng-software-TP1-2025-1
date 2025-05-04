import 'package:diary_fit/tads/anamnesis.dart';
import 'package:diary_fit/tads/client.dart';
import 'package:diary_fit/tads/patient_data.dart';
import 'package:diary_fit/values/app_api_routes.dart';

// Class responsible to parse the json data to Diary Fit TADs
class ApiParser {
  ApiParser._(); // Private constructor to prevent instantiation

  static ClientAuth parseLogin(
    String username,
    Map<String, dynamic> jsonData,
  ) {
    final accessToken = jsonData[AppApiRoutes.backendAccessTokenLabel];
    final clientType = jsonData[AppApiRoutes.backendUserTypeLabel];

    return ClientAuth(
        username: username,
        accessToken: accessToken,
        clientType: _parseClientType(clientType));
  }

  static Map<String, List<WeightData>> parseWeight(
    List<Map<String, dynamic>> jsonDataList,
  ) {
    final Map<String, List<WeightData>> map = {};
    for (final v in jsonDataList) {
      final key = v[AppApiRoutes.backendWeightUsernameLabel];

      final weight = WeightData(
          weight: double.parse(v[AppApiRoutes.backendWeightValueLabel]),
          date: DateTime.parse(v[AppApiRoutes.backendWeightDateLabel]));

      if (map.containsKey(key)) {
        map[key]!.add(weight);
      } else {
        map[key] = [weight];
      }
    }
    return map;
  }

  static Map<String, Anamnesis>? parseAnamnesis(
    List<Map<String, dynamic>> jsonDataList,
  ) {
    if (jsonDataList.isNotEmpty) {
      return {
        for (final v in jsonDataList)
          v[AppApiRoutes.backendAnamnesisUsernameLabel]: Anamnesis(
              age: v[AppApiRoutes.backendAnamnesisAgeLabel],
              height: double.parse(v[AppApiRoutes.backendAnamnesisHeightLabel]),
              initialWeight:
                  double.parse(v[AppApiRoutes.backendAnamnesisWeightLabel]),
              allergies: v[AppApiRoutes.backendAnamnesisAllergiesLabel],
              goal: v[AppApiRoutes.backendAnamnesisGoalLabel])
      };
    }

    return null;
  }

  static Map<ClientType, String> parsePatientRelationship(
    List<Map<String, dynamic>> jsonData,
  ) {
    final Map<ClientType, String> returnedData = {};

    for (final data in jsonData) {
      final String professionalName =
          data[AppApiRoutes.backendRelationshipProfessionalLabel];
      final professionalType = _parseClientType(
        data[AppApiRoutes.backendRelationshipProfessionalTypeLabel],
      );

      returnedData[professionalType] = professionalName;
    }

    return returnedData;
  }

  static Map<String, ClientPatient>? parseProfessionalRelationship(
    List<Map<String, dynamic>> jsonData,
  ) {
    if (jsonData.isNotEmpty) {
      return {
        for (final v in jsonData)
          v[AppApiRoutes.backendRelationshipPatientLabel]: ClientPatient(
              username: v[AppApiRoutes.backendRelationshipPatientLabel])
      };
    }

    return null;
  }

  static ClientType _parseClientType(String clientType) {
    switch (clientType) {
      case AppApiRoutes.backendPatientType:
        return ClientType.patient;

      case AppApiRoutes.backendTrainerType:
        return ClientType.trainer;

      case AppApiRoutes.backendNutritionistType:
        return ClientType.nutritionist;

      default:
        throw Exception('ApiParser: unknown ClientType');
    }
  }

  static Map<String, List<FoodMenuData>> parseFoodMenu(
    List<Map<String, dynamic>> jsonDataList,
  ) {
    final Map<String, List<FoodMenuData>> map = {};

    for (final v in jsonDataList) {
      final key = v[AppApiRoutes.backendFoodMenuUsernameLabel];

      final food = FoodMenuData(
        description: v[AppApiRoutes.backendFoodMenuDescriptionLabel],
        start: DateTime.parse(v[AppApiRoutes.backendFoodMenuStartLabel]),
        end: DateTime.parse(
          v[AppApiRoutes.backendFoodMenuEndLabel],
        ),
      );

      if (map.containsKey(key)) {
        map[key]!.add(food);
      } else {
        map[key] = [food];
      }

    }

    return map;
  }

  static Map<String, List<WorkoutSheetData>> parseWorkoutSheet(
    List<Map<String, dynamic>> jsonDataList,
  ) {
    final Map<String, List<WorkoutSheetData>> map = {};
    for (final v in jsonDataList) {
      final key = v[AppApiRoutes.backendWorkoutSheetUsernameLabel];

      final workoutSheet = WorkoutSheetData(
        description: v[AppApiRoutes.backendWorkoutSheetDescriptionLabel],
        start: DateTime.parse(v[AppApiRoutes.backendWorkoutSheetStartLabel]),
        end: DateTime.parse(
          v[AppApiRoutes.backendWorkoutSheetEndLabel],
        ),
      );

      if (map.containsKey(key)) {
        map[key]!.add(workoutSheet);
      } else {
        map[key] = [workoutSheet];
      }
    }

    return map;
  }

  static Map<String, List<MealData>> parseMeal(
    List<Map<String, dynamic>> jsonDataList,
  ) {
    final Map<String, List<MealData>> map = {};
    for (final v in jsonDataList) {
      final key = v[AppApiRoutes.backendMealUsernameLabel];

      final meal = MealData(
        description: v[AppApiRoutes.backendMealDescriptionLabel],
        date: DateTime.parse(v[AppApiRoutes.backendMealDateLabel]),
      );

      if (map.containsKey(key)) {
        map[key]!.add(meal);
      } else {
        map[key] = [meal];
      }
    }

    return map;
  }

  static Map<String, List<ExerciseData>> parseExercise(
    List<Map<String, dynamic>> jsonDataList,
  ) {
    final Map<String, List<ExerciseData>> map = {};
    for (final v in jsonDataList) {
      final key = v[AppApiRoutes.backendExerciseUsernameLabel];

      final exercise = ExerciseData(
        description: v[AppApiRoutes.backendExerciseDescriptionLabel],
        date: DateTime.parse(v[AppApiRoutes.backendExerciseDateLabel]),
      );

      if (map.containsKey(key)) {
        map[key]!.add(exercise);
      } else {
        map[key] = [exercise];
      }
    }

    return map;
  }
}

class ClientAuth {
  final String username;
  final String accessToken;
  final ClientType clientType;

  ClientAuth({
    required this.username,
    required this.accessToken,
    required this.clientType,
  });
}
