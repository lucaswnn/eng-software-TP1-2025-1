class Client {
  final String name;
  final int id;
  const Client({required this.name, required this.id});
}

class ClientTrainer extends Client {
  const ClientTrainer({required String name, required int id})
      : super(name: name, id: id);
}

class ClientNutritionist extends Client {
  const ClientNutritionist({required String name, required int id})
      : super(name: name, id: id);
}

class ClientPatient extends Client {
  const ClientPatient({required String name, required int id})
      : super(name: name, id: id);
}
