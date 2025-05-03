import 'package:diary_fit/tads/anamnesis.dart';
import 'package:diary_fit/tads/weight_data.dart';

enum ClientType { trainer, nutritionist, patient }

abstract class Client {
  final String username;

  Client({required this.username});

  @override
  String toString() => 'Username: $username';
}

abstract class ClientProfessional extends Client {
  Map<String, ClientPatient>? clients;

  ClientProfessional({
    required super.username,
    this.clients,
  });
}

class ClientTrainer extends ClientProfessional {
  ClientTrainer({
    required super.username,
    super.clients,
  });
}

class ClientNutritionist extends ClientProfessional {
  ClientNutritionist({
    required super.username,
    super.clients,
  });
}

class ClientPatient extends Client {
  List<WeightData>? weightData;
  Anamnesis? anamnesis;
  String? nutritionist;
  String? trainer;

  ClientPatient({
    required super.username,
    this.nutritionist,
    this.trainer,
    this.weightData,
    this.anamnesis,
  });
}
