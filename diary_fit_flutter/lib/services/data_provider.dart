import 'dart:collection';
import 'package:table_calendar/table_calendar.dart';
import 'package:diary_fit/tads/calendar_event.dart';
import 'package:flutter/material.dart';

class DataProvider extends ChangeNotifier {
  final _events = LinkedHashMap<DateTime, List<CalendarEvent>>(
    equals: isSameDay,
    hashCode: _getHashCode,
  );

  List<CalendarEvent> getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  List<CalendarEvent> getEventsForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = _daysInRange(start, end);

    return [
      for (final d in days) ... getEventsForDay(d),
    ];
  }

  List<DateTime> _daysInRange(DateTime first, DateTime last) {
    final dayCount = last.difference(first).inDays + 1;
    return List.generate(
      dayCount,
      (index) => DateTime.utc(first.year, first.month, first.day + index),
    );
  }
}

int _getHashCode(DateTime key) =>
    key.day * 1000000 + key.month * 10000 + key.year;
