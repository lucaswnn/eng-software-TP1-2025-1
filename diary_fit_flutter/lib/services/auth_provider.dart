import 'package:diary_fit/exceptions/exceptions.dart';
import 'package:diary_fit/services/api_access.dart';
import 'package:diary_fit/tads/client.dart';
import 'package:diary_fit/values/app_strings.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  String? _accessToken;
  String? get accessToken => _accessToken;
  
  ClientType? _clientType;
  final String _clientName = 'fulano';
  bool _isLoading = false;

  String? _loginErrorMessage;
  String? get errorMessage => _loginErrorMessage;

  String? _registerErrorMessage;
  String? get registerErrorMessage => _registerErrorMessage;

  bool get isLoading => _isLoading;
  bool get isAuthenticated => _accessToken != null;
  ClientType get clientType => _clientType ?? ClientType.patient;

  Future<void> authenticate(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final clientAuth = await ApiAccess.login(username, password);
      _accessToken = clientAuth.accessToken;
      _clientType = clientAuth.clientType;
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

  Client getClientInstance() {
    switch (_clientType) {
      case ClientType.trainer:
        return ClientTrainer(name: _clientName, id: 0);
      case ClientType.nutritionist:
        return ClientNutritionist(name: _clientName, id: 0);
      case ClientType.patient:
        return ClientPatient(name: _clientName, id: 0);
      default:
        throw Exception('Unknown client type');
    }
  }
}
