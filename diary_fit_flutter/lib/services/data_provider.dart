import 'dart:collection';
import 'package:diary_fit/services/api_access.dart';
import 'package:diary_fit/services/api_parser.dart';
import 'package:diary_fit/tads/client.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:diary_fit/tads/calendar_event.dart';
import 'package:flutter/material.dart';

class DataProvider extends ChangeNotifier {
  Client? _client;
  Client? get client => _client;

  bool get isDataLoaded => _client != null;

  bool isLoading = false;

  Future<void> loadData(ClientAuth clientAuth) async {
    isLoading = true;
    notifyListeners();

    switch (clientAuth.clientType) {
      case ClientType.patient:
        _loadPatientData(clientAuth);
      default:
        throw '';
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> _loadPatientData(ClientAuth clientAuth) async {
    final authToken = clientAuth.accessToken;

    //final jsonWeightData = await ApiAccess.getWeightData(authToken);
    //final jsonMealData = await ApiAccess.getMealData(authToken);
    //final jsonExerciseData = await ApiAccess.getExerciseData(authToken);
    final jsonAnamnesisData = await ApiAccess.getAnamnesisData(authToken);
    //final jsonFoodMenudata = await ApiAccess.getFoodMenudata(authToken);
    final jsonRelationshipData = await ApiAccess.getRelationshipData(authToken);
    //final jsonWorkoutSheetData = await ApiAccess.getWorkoutSheetData(authToken);

    final anamnesisData = ApiParser.parseAnamnesis(jsonAnamnesisData)?.first;
    final relationship = ApiParser.parsePatientRelationship(
      jsonRelationshipData,
    );
    
    _client = ClientPatient(
      username: clientAuth.username,
      trainer: relationship[ClientType.trainer],
      nutritionist: relationship[ClientType.nutritionist],
      anamnesis: anamnesisData,
    );
  }

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
      for (final d in days) ...getEventsForDay(d),
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
