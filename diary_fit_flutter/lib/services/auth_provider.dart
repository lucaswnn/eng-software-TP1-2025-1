import 'package:diary_fit/services/api_access.dart';
import 'package:diary_fit/services/client_auth.dart';
import 'package:diary_fit/tads/client.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  String? _accessToken;
  ClientType? _clientType;
  final String _clientName = 'fulano';
  bool _isLoading = false;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool get isLoading => _isLoading;
  bool get isAuthenticated => _accessToken != null;
  ClientType get clientType => _clientType ?? ClientType.unknown;

  Future<void> authenticate(String username, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      final clientAuth = await ApiAccess.login(username, password);
      _accessToken = clientAuth.accessToken;
      _clientType = clientAuth.clientType;
    } catch (e) {
      _errorMessage = e.toString();
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
