import 'package:diary_fit/tads/client.dart';

class ClientAuth {
  final String name;
  final String accessToken;
  final String refreshToken;
  final ClientType clientType;

  ClientAuth({
    required this.name,
    required this.accessToken,
    required this.refreshToken,
    required this.clientType,
  });
}
