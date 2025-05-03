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

  static List<WeightData> parseWeight(
    List<Map<String, dynamic>> jsonDataList,
  ) {
    return [
      for (final v in jsonDataList)
        WeightData(
            weight: double.parse(v[AppApiRoutes.backendWeightValueLabel]),
            date: DateTime.parse(v[AppApiRoutes.backendWeightDateLabel]))
    ];
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

  // TODO: implementar parsers para cardápio, ficha, refeições e exercícios
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
