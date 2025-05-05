import 'package:flutter/widgets.dart';

enum CalendarEventType {
  foodMenu,
  workoutSheet,
  mealRegister,
  exerciseRegister,
  weightRegister
}

// Base class for Calendar events
abstract class CalendarEvent {
  final CalendarEventType? type;
  const CalendarEvent({this.type});

  Widget buildContent(BuildContext context);
}

class CalendarNullEvent extends CalendarEvent{
  const CalendarNullEvent();
  
  @override
  Widget buildContent(BuildContext context) {
    return const Center();
  }
}

class CalendarWeightEvent extends CalendarEvent {
  final double weight;

  CalendarWeightEvent({required this.weight}) : super(type: CalendarEventType.weightRegister);

  // TODO: melhorar o buildContent
  @override
  Widget buildContent(BuildContext context) {
    return Center(child: Text('peso: $weight'));
  }
  @override
  String toString() {
    return 'Peso do dia: $weight';
  }
}

class CalendarMealEvent extends CalendarEvent {
  final String description;

  CalendarMealEvent({required this.description}) : super(type: CalendarEventType.mealRegister);

  // TODO: melhorar o buildContent
  @override
  Widget buildContent(BuildContext context) {
    return Center(child: Text('refeição: $description'));
  }
  @override
  String toString() {
    return 'Refeição do dia: $description';
  }
}

class CalendarExerciseEvent extends CalendarEvent {
  final String description;

  CalendarExerciseEvent({required this.description}) : super(type: CalendarEventType.exerciseRegister);

  // TODO: melhorar o buildContent
  @override
  Widget buildContent(BuildContext context) {
    return Center(child: Text('exercício: $description'));
  }
  @override
  String toString() {
    return 'Exercicio do dia: $description';
  }
}

class CalendarFoodMenuEvent extends CalendarEvent {
  final String description;

  CalendarFoodMenuEvent({required this.description}) : super(type: CalendarEventType.foodMenu);

  // TODO: melhorar o buildContent
  @override
  Widget buildContent(BuildContext context) {
    return Center(child: Text('cardápio: $description'));
  }
  @override
  String toString() {
    return 'Cardápio do dia: $description';
  }
}

class CalendarWorkoutSheetEvent extends CalendarEvent {
  final String description;

  CalendarWorkoutSheetEvent({required this.description}) : super(type: CalendarEventType.workoutSheet);

  // TODO: melhorar o buildContent
  @override
  Widget buildContent(BuildContext context) {
    return Center(child: Text('ficha de exercícios: $description'));
  }
  @override
  String toString() {
    return 'Ficha de exercicio do dia: $description';
  }
}