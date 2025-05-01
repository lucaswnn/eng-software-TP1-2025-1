import 'package:diary_fit/exceptions/exceptions.dart';
import 'package:diary_fit/services/api_access.dart';
import 'package:diary_fit/services/api_parser.dart';
import 'package:diary_fit/tads/client.dart';
import 'package:diary_fit/values/app_strings.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  // ClientAuth contains:
  // - API access token
  // - Username
  // - Client type
  ClientAuth? _clientAuth;
  ClientAuth? get clientAuth => _clientAuth;

  // Loading flag
  // Useful for loading widgets, e.g. waiting for authentication
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Login exception message
  String? _loginErrorMessage;
  String? get errorMessage => _loginErrorMessage;

  // Register exception message
  String? _registerErrorMessage;
  String? get registerErrorMessage => _registerErrorMessage;

  // The user is authenticated when access token is not null
  bool get isAuthenticated => _clientAuth != null;

  Future<void> authenticate(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final jsonData = await ApiAccess.login(username, password);
      _clientAuth = ApiParser.parseLogin(username, jsonData);
    } on UnauthorizedException {
      _loginErrorMessage = AppStrings.wrongLoginOrPasswordError;
    } catch (e) {
      _loginErrorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> register(
    String username,
    String password,
    ClientType clientType,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      await ApiAccess.register(username, password, clientType);
    } on AlreadyExistsException {
      _registerErrorMessage = AppStrings.loginAlreadyExistsError;
    } catch (e) {
      _registerErrorMessage = '${AppStrings.genericServerError}\n$e';
    }

    _isLoading = false;
    notifyListeners();
  }
}
