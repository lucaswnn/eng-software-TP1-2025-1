import 'dart:collection';

import 'package:diary_fit/tads/calendar_event.dart';
import 'package:diary_fit/tads/weight_data.dart';

class CalendarParser {
  const CalendarParser._();

  static void addWeightDataToMap(
    LinkedHashMap<DateTime, List<CalendarEvent>> map,
    List<WeightData> weightData,
  ) {
    for (final w in weightData) {
      final date = w.date;
      final weight = w.weight;
      final event = CalendarWeightEvent(weight: weight);
      if (map.containsKey(date)) {
        map[date]!.add(event);
      } else {
        map[date] = [event];
      }
    }
  }
}
