import 'package:flutter/widgets.dart';

enum CalendarEventType {
  foodMenu,
  workoutSheet,
  mealRegister,
  exerciseRegister,
  weightRegister
}

// TODO: implementar mais as seguintes superclasses:
// refeição, exercício, ficha e cardápio

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
}