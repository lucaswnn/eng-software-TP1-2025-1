import 'dart:async';
import 'dart:convert';

import 'package:diary_fit/services/client_auth.dart';
import 'package:diary_fit/values/app_api_requests.dart';
import 'package:http/http.dart' as http;

const Map<ClientType, String> clientTypeApiMap = {
  ClientType.trainer: 'educador_fisico',
  ClientType.nutritionist: 'nutricionista',
  ClientType.patient: 'paciente',
};

class ApiAccess {
  ApiAccess._(); // Private constructor to prevent instantiation

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
              clientType: ClientType.nutritionist);
        }
      case 400:
        {
          throw Exception('Invalid username or password');
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

    if (response.statusCode != 201) {
      throw Exception('Failed to register: ${response.statusCode}');
    }
  }
}
