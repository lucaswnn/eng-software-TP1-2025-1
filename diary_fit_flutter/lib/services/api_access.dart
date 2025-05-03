import 'dart:async';
import 'dart:convert';

import 'package:diary_fit/exceptions/exceptions.dart';
import 'package:diary_fit/tads/client.dart';
import 'package:diary_fit/values/app_api_routes.dart';
import 'package:diary_fit/values/app_strings.dart';
import 'package:http/http.dart' as http;

const Map<ClientType, String> clientTypeApiMap = {
  ClientType.trainer: 'educador_fisico',
  ClientType.nutritionist: 'nutricionista',
  ClientType.patient: 'paciente',
};

class ApiAccess {
  ApiAccess._();

  static dynamic _processResponse(
    http.Response response,
    String unknownExceptionMessage,
  ) {
    switch (response.statusCode) {
      case 200 || 201:
        return json.decode(response.body);
      case 400:
        throw BadRequestException(AppStrings.badRequestExceptionMessage);
      case 401:
        throw UnauthorizedException(AppStrings.unauthorizedExceptionMessage);
      case 403:
        throw ForbiddenException(AppStrings.forbiddenExceptionMessage);
      case 404:
        throw NotFoundException(AppStrings.notFoundExceptionMessage);
      default:
        throw Exception('$unknownExceptionMessage: ${response.statusCode}');
    }
  }

  static List<Map<String, dynamic>> _processRawList(List<dynamic> rawList) {
    return List<Map<String, dynamic>>.from(rawList);
  }

  static Future<dynamic> _genericGetWithAuth({
    required String? authToken,
    required String url,
    required String unknownExceptionMessage,
  }) async {
    if (authToken == null) {
      throw UnauthorizedException(AppStrings.nullTokenExceptionMessage);
    }

    final uri = Uri.parse(url);
    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
    );

    return _processResponse(response, unknownExceptionMessage);
  }

  static Future<dynamic> _genericPostWithAuth({
    required String? authToken,
    required String url,
    required Map<String, dynamic> body,
    required String unknownExceptionMessage,
  }) async {
    if (authToken == null) {
      throw UnauthorizedException(AppStrings.nullTokenExceptionMessage);
    }

    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
      body: json.encode(body),
    );

    return _processResponse(response, unknownExceptionMessage);
  }

  static Future<Map<String, dynamic>> login(
    String username,
    String password,
  ) async {
    final url = Uri.parse(AppApiRoutes.login);

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'username': username,
        'password': password,
      }),
    );

    return _processResponse(response, 'Failed to login');
  }

  static Future<Map<String, dynamic>> register(
    String username,
    String password,
    ClientType clientType,
  ) async {
    final url = Uri.parse(AppApiRoutes.register);

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'username': username,
        'password': password,
        'tipo': clientTypeApiMap[clientType],
      }),
    );

    return _processResponse(response, 'Failed to register');
  }

  static Future<Map<String, dynamic>> getCalendarData(String? authToken) async {
    return await _genericGetWithAuth(
      authToken: authToken,
      url: AppApiRoutes.calendarData,
      unknownExceptionMessage: 'Failed to fetch calendar data',
    );
  }

  // funciona
  static Future<List<Map<String, dynamic>>> getWeightData(
      String? authToken) async {
    return _processRawList(
      await _genericGetWithAuth(
        authToken: authToken,
        url: AppApiRoutes.weightData,
        unknownExceptionMessage: 'Failed to fetch weight data',
      ),
    );
  }

  // funciona
  static Future<Map<String, dynamic>> postWeightData(
    String? authToken,
    double weight,
    DateTime date,
  ) async {
    final body = {
      'peso': weight,
      'data': _dateTimeStringFormat(date),
    };

    return await _genericPostWithAuth(
      authToken: authToken,
      url: AppApiRoutes.weightData,
      body: body,
      unknownExceptionMessage: 'Failed to post weight data',
    );
  }

  // funciona
  static Future<Map<String, dynamic>> getMealData(String? authToken) async {
    return await _genericGetWithAuth(
      authToken: authToken,
      url: AppApiRoutes.mealData,
      unknownExceptionMessage: 'Failed to fetch meal data',
    );
  }

  // funciona
  static Future<Map<String, dynamic>> postMealData(
    String? authToken,
    String description,
    DateTime date,
  ) async {
    final body = {
      'descricao': 'xtudo',
      'data': _dateTimeStringFormat(date),
      'nutricionista_username': 'n1',
    };

    return await _genericPostWithAuth(
      authToken: authToken,
      url: AppApiRoutes.mealData,
      body: body,
      unknownExceptionMessage: 'Failed to post meal data',
    );
  }

  // funciona
  static Future<Map<String, dynamic>> getExerciseData(String? authToken) async {
    return await _genericGetWithAuth(
      authToken: authToken,
      url: AppApiRoutes.exerciseData,
      unknownExceptionMessage: 'Failed to fetch exercise data',
    );
  }

  // funciona
  static Future<Map<String, dynamic>> postExerciseData(
    String? authToken,
    String trainer,
    String description,
    DateTime date,
  ) async {
    final body = {
      'data': _dateTimeStringFormat(date),
      'treinador_username': trainer,
      'descricao': description,
    };

    return await _genericPostWithAuth(
      authToken: authToken,
      url: AppApiRoutes.exerciseData,
      body: body,
      unknownExceptionMessage: 'Failed to post exercise data',
    );
  }

  // funciona
  static Future<List<Map<String, dynamic>>> getAnamnesisData(
      String? authToken) async {
    return _processRawList(
      await _genericGetWithAuth(
        authToken: authToken,
        url: AppApiRoutes.anamnesisData,
        unknownExceptionMessage: 'Failed to fetch anamnesis data',
      ),
    );
  }

  // funciona
  static Future<Map<String, dynamic>> postAnamnesisData(
    String? authToken,
    int age,
    double height,
    double initialWeight,
    String allergies,
    String goal,
  ) async {
    final body = {
      'idade': age,
      'altura_cm': height,
      'peso_inicial': initialWeight,
      'alergias': allergies,
      'objetivo': goal,
    };

    return await _genericPostWithAuth(
      authToken: authToken,
      url: AppApiRoutes.anamnesisData,
      body: body,
      unknownExceptionMessage: 'Failed to fetch anamnesis data',
    );
  }

  // funciona
  static Future<Map<String, dynamic>> getFoodMenudata(String? authToken) async {
    return await _genericGetWithAuth(
      authToken: authToken,
      url: AppApiRoutes.foodMenuData,
      unknownExceptionMessage: 'Failed to fetch food menu data',
    );
  }

  // funciona
  static Future<Map<String, dynamic>> postFoodMenuData(
    String? authToken,
    String user,
    String description,
    DateTime start,
    DateTime end,
  ) async {
    final body = {
      'paciente_username': user,
      'description': description,
      'data_inicio': _dateTimeStringFormat(start),
      'data_fim': _dateTimeStringFormat(end),
    };

    return await _genericPostWithAuth(
      authToken: authToken,
      url: AppApiRoutes.foodMenuData,
      body: body,
      unknownExceptionMessage: 'Failed to post food menu data',
    );
  }

  // funciona
  static Future<List<Map<String, dynamic>>> getRelationshipData(
      String? authToken) async {
    return _processRawList(
      await _genericGetWithAuth(
        authToken: authToken,
        url: AppApiRoutes.relationshipData,
        unknownExceptionMessage: 'Failed to fetch relationship data',
      ),
    );
  }

  // funciona
  static Future<Map<String, dynamic>> postRelationshipData(
    String? authToken,
    String user,
  ) async {
    final body = {
      'paciente_username_input': user,
    };

    return await _genericPostWithAuth(
      authToken: authToken,
      url: AppApiRoutes.relationshipData,
      body: body,
      unknownExceptionMessage: 'Failed to post relationship data',
    );
  }

  // funciona
  static Future<Map<String, dynamic>> getWorkoutSheetData(
      String? authToken) async {
    return await _genericGetWithAuth(
      authToken: authToken,
      url: AppApiRoutes.workoutSheetData,
      unknownExceptionMessage: 'Failed to fetch workout sheet data',
    );
  }

  // funciona
  static Future<Map<String, dynamic>> postWorkoutSheetData(
    String? authToken,
    String user,
    String description,
    DateTime start,
    DateTime end,
  ) async {
    final body = {
      'usuario_username': user,
      'descricao': description,
      'data_inicio': _dateTimeStringFormat(start),
      'data_fim': _dateTimeStringFormat(end),
    };

    return await _genericPostWithAuth(
      authToken: authToken,
      url: AppApiRoutes.workoutSheetData,
      body: body,
      unknownExceptionMessage: 'Failed to post workout sheet data',
    );
  }

  static String _dateTimeStringFormat(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}
