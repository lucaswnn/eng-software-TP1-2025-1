enum CalendarEventType { nutrition, fitness, health }

abstract class CalendarEvent {
  final String content;
  final CalendarEventType type;

  const CalendarEvent({
    required this.content,
    required this.type,
  });
}

class HealthCalendarEvent extends CalendarEvent {
  const HealthCalendarEvent({required String content})
      : super(
          content: content,
          type: CalendarEventType.health,
        );
}

class FitnessCalendarEvent extends CalendarEvent {
  const FitnessCalendarEvent({required String content})
      : super(
          content: content,
          type: CalendarEventType.fitness,
        );
}

class NutritionCalendarEvent extends CalendarEvent {
  const NutritionCalendarEvent({required String content})
      : super(
          content: content,
          type: CalendarEventType.nutrition,
        );
}