import 'dart:collection';
import 'package:diary_fit/services/api_access.dart';
import 'package:diary_fit/services/api_parser.dart';
import 'package:diary_fit/services/calendar_parser.dart';
import 'package:diary_fit/tads/client.dart';
import 'package:diary_fit/tads/weight_data.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:diary_fit/tads/calendar_event.dart';
import 'package:flutter/material.dart';

class DataProvider extends ChangeNotifier {
  Client? _client;
  Client? get client => _client;

  ClientPatient? _currentPatient;
  ClientPatient? get currentPatient => _currentPatient;
  set currentPatient(ClientPatient? patient) => _currentPatient = patient;

  LinkedHashMap<DateTime, List<CalendarEvent>>? _calendarData;
  LinkedHashMap<DateTime, List<CalendarEvent>>? get calendarData =>
      _calendarData;

  List<WeightData>? _weightData;
  List<WeightData>? get weightData => _weightData;

  bool get isDataLoaded => _client != null;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage {
    final ret = _errorMessage;
    _errorMessage = null;
    return ret;
  }

  set client(Client? client) {
    _client = client;
    notifyListeners();
  }

  Future<void> loadData(ClientAuth clientAuth) async {
    _isLoading = true;
    notifyListeners();

    switch (clientAuth.clientType) {
      case ClientType.patient:
        await _loadPatientData(clientAuth);
      case ClientType.nutritionist:
        await _loadNutritionistData(clientAuth);
      default:
        throw Exception('Undefined client type');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _loadPatientData(ClientAuth clientAuth) async {
    final authToken = clientAuth.accessToken;

    final jsonWeightData = await ApiAccess.getWeightData(authToken);
    //final jsonMealData = await ApiAccess.getMealData(authToken);
    //final jsonExerciseData = await ApiAccess.getExerciseData(authToken);
    final jsonAnamnesisData = await ApiAccess.getAnamnesisData(authToken);
    //final jsonFoodMenudata = await ApiAccess.getFoodMenudata(authToken);
    final jsonRelationshipData = await ApiAccess.getRelationshipData(authToken);
    //final jsonWorkoutSheetData = await ApiAccess.getWorkoutSheetData(authToken);

    final weightData = ApiParser.parseWeight(jsonWeightData);

    final anamnesisData =
        ApiParser.parseAnamnesis(jsonAnamnesisData)?.values.first;

    final relationship = ApiParser.parsePatientRelationship(
      jsonRelationshipData,
    );

    _client = ClientPatient(
      username: clientAuth.username,
      trainer: relationship[ClientType.trainer],
      nutritionist: relationship[ClientType.nutritionist],
      weightData: weightData,
      anamnesis: anamnesisData,
    );
  }

  Future<void> _loadNutritionistData(ClientAuth clientAuth) async {
    final authToken = clientAuth.accessToken;

    //final jsonWeightData = await ApiAccess.getWeightData(authToken);
    //final jsonMealData = await ApiAccess.getMealData(authToken);
    //final jsonExerciseData = await ApiAccess.getExerciseData(authToken);
    final jsonAnamnesisData = await ApiAccess.getAnamnesisData(authToken);
    //final jsonFoodMenudata = await ApiAccess.getFoodMenudata(authToken);
    final jsonRelationshipData = await ApiAccess.getRelationshipData(authToken);
    //final jsonWorkoutSheetData = await ApiAccess.getWorkoutSheetData(authToken);

    final anamnesisData = ApiParser.parseAnamnesis(jsonAnamnesisData);
    final relationship = ApiParser.parseProfessionalRelationship(
      jsonRelationshipData,
    );

    if (anamnesisData != null) {
      for (final client in anamnesisData.keys) {
        relationship?[client]?.anamnesis = anamnesisData[client];
      }
    }

    _client = ClientNutritionist(
      username: clientAuth.username,
      clients: relationship,
    );

    if(relationship != null && relationship.isNotEmpty){
      _currentPatient = relationship.values.first;
    }
  }

  void processCalendarData(ClientAuth clientAuth){
    _isLoading = true;
    notifyListeners();

    switch (clientAuth.clientType) {
      case ClientType.patient:
        _processPatientCalendarData();
      case ClientType.nutritionist:
        _processNutritionistCalendarData();
      default:
        throw Exception('Undefined client type');
    }

    _isLoading = false;
    notifyListeners();
  }

  void _processPatientCalendarData() {
    if (_client != null) {
      if (_calendarData == null) {
        _calendarData = LinkedHashMap(
          equals: isSameDay,
          hashCode: _getHashCode,
        );

        CalendarParser.addWeightDataToMap(
            _calendarData!, (_client as ClientPatient).weightData!);

        notifyListeners();
      }
    }
  }

  void _processNutritionistCalendarData(){
    
  }

  Future<void> sendWeight(
    ClientAuth clientAuth,
    double weight,
    DateTime date,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      ApiAccess.postWeightData(
        clientAuth.accessToken,
        weight,
        date,
      );
      CalendarParser.addWeightDataToMap(
          _calendarData!, [WeightData(weight: weight, date: date)]);
    } catch (e) {
      _errorMessage = 'Não foi possível enviar os dados: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> sendAnamnesis(
      ClientAuth clientAuth, ClientPatient client) async {
    _isLoading = true;
    notifyListeners();

    final anamnesis = client.anamnesis;
    try {
      ApiAccess.postAnamnesisData(
        clientAuth.accessToken,
        (anamnesis?.age)!,
        (anamnesis?.height)!,
        (anamnesis?.initialWeight)!,
        (anamnesis?.allergies)!,
        (anamnesis?.goal)!,
      );
    } catch (e) {
      _errorMessage = 'Não foi possível enviar os dados: $e';
    }

    _isLoading = false;
    notifyListeners();
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

  void cleanData(){
    _client = null;
    _calendarData = null;
    notifyListeners();
  }
}

int _getHashCode(DateTime key) =>
    key.day * 1000000 + key.month * 10000 + key.year;
