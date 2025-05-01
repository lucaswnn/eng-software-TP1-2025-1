class Anamnesis {
  final int age;
  final double height;
  final double initialWeight;
  final String allergies;
  final String goal;

  const Anamnesis({
    required this.age,
    required this.height,
    required this.initialWeight,
    required this.allergies,
    required this.goal,
  });

  Map<String, dynamic> get anamnesisDataMap => {
        'Idade': age,
        'Altura': height,
        'Peso inicial': initialWeight,
        'Alergias': allergies,
        'Objetivo': goal,
      };

  @override
  String toString() => '$anamnesisDataMap';
}
