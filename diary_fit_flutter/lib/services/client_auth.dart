enum ClientType { trainer, nutritionist, patient, unknown }

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
