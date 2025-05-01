import 'package:diary_fit/tads/anamnesis.dart';
import 'package:diary_fit/tads/client.dart';
import 'package:diary_fit/values/app_api_routes.dart';

class ApiParser {
  ApiParser._();

  static ClientAuth parseLogin(String username, Map<String, dynamic> jsonData) {
    final accessToken = jsonData[AppApiRoutes.backendAccessTokenLabel];
    final clientType = jsonData[AppApiRoutes.backendUserTypeLabel];

    return ClientAuth(
        username: username,
        accessToken: accessToken,
        clientType: _parseClientType(clientType));
  }

  static List<Anamnesis>? parseAnamnesis(
      List<Map<String, dynamic>> jsonDataList) {
    if (jsonDataList.isNotEmpty) {
      final anamnesisData = <Anamnesis>[];

      for (final jsonData in jsonDataList) {
        final age = jsonData[AppApiRoutes.backendAnamnesisAgeLabel];
        final height = jsonData[AppApiRoutes.backendAnamnesisHeightLabel];
        final weight = jsonData[AppApiRoutes.backendAnamnesisWeightLabel];
        final allergies = jsonData[AppApiRoutes.backendAnamnesisAllergiesLabel];
        final goal = jsonData[AppApiRoutes.backendAnamnesisGoalLabel];

        anamnesisData.add(
          Anamnesis(
            age: age,
            height: double.parse(height),
            initialWeight: double.parse(weight),
            allergies: allergies,
            goal: goal,
          ),
        );
      }

      return anamnesisData;
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
