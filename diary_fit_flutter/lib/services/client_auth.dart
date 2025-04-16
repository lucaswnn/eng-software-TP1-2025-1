import 'dart:math';

import 'package:diary_fit/tads/client.dart';

enum ClientType { trainer, nutritionist, patient }

class ClientAuth{
  late final Client client;

  ClientType getAuthType() {
    final random = Random();
    final choice = ClientType.values[random.nextInt(ClientType.values.length)];
    switch (choice) {
      case ClientType.trainer:
        client = const ClientTrainer(name: 'Treinador', id: 1);
      case ClientType.nutritionist:
        client = const ClientNutritionist(name: 'Nutricionista', id: 2);
      case ClientType.patient:
        client = const ClientPatient(name: 'Treinador', id: 3);
    }
    return choice;
  }
}
