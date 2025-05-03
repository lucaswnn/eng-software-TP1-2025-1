import 'package:flutter/widgets.dart';

enum CalendarEventType {
  foodMenu,
  workoutSheet,
  mealRegister,
  exerciseRegister,
  weightRegister,
}

abstract class CalendarEvent {
  const CalendarEvent();

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

  CalendarWeightEvent({required this.weight});

  @override
  Widget buildContent(BuildContext context) {
    return Center(child: Text('peso: $weight'));
  }
}
