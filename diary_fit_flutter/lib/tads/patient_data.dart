// Patient components

class WeightData {
  final double weight;
  final DateTime date;

  const WeightData({
    required this.weight,
    required this.date,
  });
}

class FoodMenuData {
  final String description;
  final DateTime start;
  final DateTime end;

  const FoodMenuData({
    required this.description,
    required this.start,
    required this.end,
  });
}

class WorkoutSheetData {
  final String description;
  final DateTime start;
  final DateTime end;

  const WorkoutSheetData({
    required this.description,
    required this.start,
    required this.end,
  });
}

class MealData {
  final String description;
  final DateTime date;

  const MealData({
    required this.description,
    required this.date,
  });
}

class ExerciseData {
  final String description;
  final DateTime date;

  const ExerciseData({
    required this.description,
    required this.date,
  });
}