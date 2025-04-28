import 'dart:async';
import 'dart:convert';

import 'package:diary_fit/exceptions/exceptions.dart';
import 'package:diary_fit/services/client_auth.dart';
import 'package:diary_fit/tads/client.dart';
import 'package:diary_fit/values/app_api_requests.dart';
import 'package:diary_fit/values/app_strings.dart';
import 'package:http/http.dart' as http;

const Map<ClientType, String> clientTypeApiMap = {
  ClientType.trainer: 'educador_fisico',
  ClientType.nutritionist: 'nutricionista',
  ClientType.patient: 'paciente',
};

// p1
// p2
// p3
// t1
// n1

class ApiAccess {
  ApiAccess._();

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

    final data = json.decode(response.body);
    print(data);

    switch (response.statusCode) {
      case 200:
        return data;
      case 400:
        throw BadRequestException(AppStrings.badRequestExceptionMessage);
      case 401:
        throw UnauthorizedException(AppStrings.unauthorizedExceptionMessage);
      default:
        throw Exception('$unknownExceptionMessage: ${response.statusCode}');
    }
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

    final data = json.decode(response.body);
    print(data);

    switch (response.statusCode) {
      case 200 || 201:
        return data;
      case 400:
        throw BadRequestException(AppStrings.badRequestExceptionMessage);
      case 401:
        throw UnauthorizedException(AppStrings.unauthorizedExceptionMessage);
      default:
        throw Exception('$unknownExceptionMessage: ${response.statusCode}');
    }
  }

  static Future<ClientAuth> login(String username, String password) async {
    final url = Uri.parse(AppApiRequests.login);

    final response = await http
        .post(
          url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({
            'username': username,
            'password': password,
          }),
        )
        .timeout(const Duration(seconds: 20));

    switch (response.statusCode) {
      case 200:
        {
          final data = json.decode(response.body);
          final accessToken = data[AppApiRequests.backendAccessToken];
          final refreshToken = data[AppApiRequests.backendRefreshToken];

          return ClientAuth(
              name: username,
              accessToken: accessToken,
              refreshToken: refreshToken,
              clientType: ClientType.patient);
        }
      case 401:
        {
          throw UnauthorizedException(AppStrings.unauthorizedExceptionMessage);
        }
      default:
        {
          throw Exception('Failed to login: ${response.statusCode}');
        }
    }
  }

  static Future<void> register(
    String username,
    String password,
    ClientType clientType,
  ) async {
    final url = Uri.parse(AppApiRequests.register);

    final response = await http
        .post(
          url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({
            'username': username,
            'password': password,
            'tipo': clientTypeApiMap[clientType],
          }),
        )
        .timeout(const Duration(seconds: 20));

    switch (response.statusCode) {
      case 201:
        return;
      case 400:
        throw BadRequestException(AppStrings.badRequestExceptionMessage);
      default:
        throw Exception('Failed to register: ${response.statusCode}');
    }
  }

  static Future<void> getCalendarData(String? authToken) async {
    await _genericGetWithAuth(
      authToken: authToken,
      url: AppApiRequests.calendarData,
      unknownExceptionMessage: 'Failed to fetch calendar data',
    );
  }

  static Future<void> getWeightData(String? authToken) async {
    await _genericGetWithAuth(
      authToken: authToken,
      url: AppApiRequests.weightData,
      unknownExceptionMessage: 'Failed to fetch weight data',
    );
  }

  static Future<void> postWeightData(
    String? authToken,
    double weight,
    DateTime date,
  ) async {
    final body = {
      'peso': weight,
      'data': _dateTimeStringFormat(date),
    };

    await _genericPostWithAuth(
      authToken: authToken,
      url: AppApiRequests.weightData,
      body: body,
      unknownExceptionMessage: 'Failed to post weight data',
    );
  }

  static Future<void> getMealData(String? authToken) async {
    await _genericGetWithAuth(
      authToken: authToken,
      url: AppApiRequests.mealData,
      unknownExceptionMessage: 'Failed to fetch meal data',
    );
  }

  static Future<void> postMealData(
    String? authToken,
    String description,
    DateTime date,
  ) async {
    final body = {
      'descricao': description,
      'data': _dateTimeStringFormat(date),
    };

    await _genericPostWithAuth(
      authToken: authToken,
      url: AppApiRequests.mealData,
      body: body,
      unknownExceptionMessage: 'Failed to post meal data',
    );
  }

  static Future<void> getExerciseData(String? authToken) async {
    await _genericGetWithAuth(
      authToken: authToken,
      url: AppApiRequests.exerciseData,
      unknownExceptionMessage: 'Failed to fetch exercise data',
    );
  }

  static Future<void> postExerciseData(
    String? authToken,
    String description,
    DateTime date,
    int minutesDuration,
  ) async {
    final body = {
      'data': _dateTimeStringFormat(date),
      'tipo': description,
      'duracao_minutos': minutesDuration,
    };

    await _genericPostWithAuth(
      authToken: authToken,
      url: AppApiRequests.exerciseData,
      body: body,
      unknownExceptionMessage: 'Failed to post exercise data',
    );
  }

  static Future<void> getAnamnesisData(String? authToken) async {
    await _genericGetWithAuth(
      authToken: authToken,
      url: AppApiRequests.anamnesisData,
      unknownExceptionMessage: 'Failed to fetch anamnesis data',
    );
  }

  static Future<void> getFoodData(String? authToken) async {
    await _genericGetWithAuth(
      authToken: authToken,
      url: AppApiRequests.foodData,
      unknownExceptionMessage: 'Failed to fetch food data',
    );
  }

  static Future<void> getFoodMenudata(String? authToken) async {
    await _genericGetWithAuth(
      authToken: authToken,
      url: AppApiRequests.foodMenuData,
      unknownExceptionMessage: 'Failed to fetch food menu data',
    );
  }

  static String _dateTimeStringFormat(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}
