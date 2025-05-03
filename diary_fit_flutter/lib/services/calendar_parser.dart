import 'dart:collection';

import 'package:diary_fit/tads/calendar_event.dart';
import 'package:diary_fit/tads/patient_data.dart';

// Class responsible to parse common TADs to the calendar HashMap
class CalendarParser {
  const CalendarParser._(); // Private constructor to prevent instantiation

  // TODO: implementar addFoodMenuDataToMap (cardápio), addWorkoutSheetDataToMap (ficha),
  // addMealDataToMap (refeição), addExerciseDataToMap (exercício)
  
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
