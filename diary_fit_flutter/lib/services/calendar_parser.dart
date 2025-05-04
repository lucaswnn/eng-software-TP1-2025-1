import 'dart:collection';

import 'package:diary_fit/tads/calendar_event.dart';
import 'package:diary_fit/tads/patient_data.dart';
import 'package:diary_fit/utils/date_functions.dart';

// Class responsible to parse common TADs to the calendar HashMap
class CalendarParser {
  const CalendarParser._(); // Private constructor to prevent instantiation

  static void addWeightDataToMap(
    LinkedHashMap<DateTime, List<CalendarEvent>> map,
    List<WeightData>? weightData,
  ) {
    if (weightData != null) {
      for (final data in weightData) {
        final date = data.date;
        final weight = data.weight;
        final event = CalendarWeightEvent(weight: weight);
        if (map.containsKey(date)) {
          map[date]!.add(event);
        } else {
          map[date] = [event];
        }
      }
    }
  }

  static void addMealDataToMap(
    LinkedHashMap<DateTime, List<CalendarEvent>> map,
    List<MealData>? mealData,
  ) {
    if (mealData != null) {
      for (final data in mealData) {
        final date = data.date;
        final description = data.description;
        final event = CalendarMealEvent(description: description);
        if (map.containsKey(date)) {
          map[date]!.add(event);
        } else {
          map[date] = [event];
        }
      }
    }
  }

  static void addExerciseDataToMap(
    LinkedHashMap<DateTime, List<CalendarEvent>> map,
    List<ExerciseData>? exerciseData,
  ) {
    if (exerciseData != null) {
      for (final data in exerciseData) {
        final date = data.date;
        final description = data.description;
        final event = CalendarExerciseEvent(description: description);
        if (map.containsKey(date)) {
          map[date]!.add(event);
        } else {
          map[date] = [event];
        }
      }
    }
  }

  static void addFoodMenuDataToMap(
    LinkedHashMap<DateTime, List<CalendarEvent>> map,
    List<FoodMenuData>? foodMenuData,
  ) {
    if (foodMenuData != null) {
      for (final data in foodMenuData) {
        final days = DateFunctions.daysInRange(data.start, data.end);
        final description = data.description;
        final event = CalendarFoodMenuEvent(description: description);
        for (final date in days) {
          if (map.containsKey(date)) {
            map[date]!.add(event);
          } else {
            map[date] = [event];
          }
        }
      }
    }
  }

  static void addWorkoutSheetDataToMap(
    LinkedHashMap<DateTime, List<CalendarEvent>> map,
    List<WorkoutSheetData>? workoutSheetData,
  ) {
    if (workoutSheetData != null) {
      for (final data in workoutSheetData) {
        final days = DateFunctions.daysInRange(data.start, data.end);
        final description = data.description;
        final event = CalendarWorkoutSheetEvent(description: description);
        for (final date in days) {
          if (map.containsKey(date)) {
            map[date]!.add(event);
          } else {
            map[date] = [event];
          }
        }
      }
    }
  }
}
