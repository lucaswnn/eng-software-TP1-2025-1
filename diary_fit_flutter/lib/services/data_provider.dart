import 'dart:collection';
import 'package:diary_fit/services/api_access.dart';
import 'package:diary_fit/services/api_parser.dart';
import 'package:diary_fit/services/calendar_parser.dart';
import 'package:diary_fit/tads/anamnesis.dart';
import 'package:diary_fit/tads/client.dart';
import 'package:diary_fit/tads/patient_data.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:diary_fit/tads/calendar_event.dart';
import 'package:flutter/material.dart';

// Provider ChangeNotifier responsible for dealing with authenticating data
class DataProvider extends ChangeNotifier {
  // Current UI client
  Client? _client;
  Client? get client => _client;

  // The current selected patient
  // Only used if the user is a professional
  ClientPatient? _currentPatient;
  ClientPatient? get currentPatient => _currentPatient;

  // HashMap with the calendar events
  LinkedHashMap<DateTime, List<CalendarEvent>>? _calendarData;
  LinkedHashMap<DateTime, List<CalendarEvent>>? get calendarData =>
      _calendarData;

  // Loading flag
  // Useful for loading widgets, e.g. waiting for calendar data
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // API error message
  String? _errorMessage;
  String? get errorMessage {
    final ret = _errorMessage;
    _errorMessage = null;
    return ret;
  }

  Future<void> loadData(ClientAuth clientAuth) async {
    _isLoading = true;
    notifyListeners();

    switch (clientAuth.clientType) {
      case ClientType.patient:
        await _loadPatientData(clientAuth);
      case ClientType.nutritionist:
        await _loadNutritionistData(clientAuth);
      case ClientType.trainer:
        await _loadTrainerData(clientAuth);
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _loadPatientData(ClientAuth clientAuth) async {
    final authToken = clientAuth.accessToken;

    final jsonWeightData = await ApiAccess.getWeightData(authToken);
    final weightData =
        ApiParser.parseWeight(jsonWeightData)[clientAuth.username];

    final jsonMealData = await ApiAccess.getMealData(authToken);
    final mealData = ApiParser.parseMeal(jsonMealData)[clientAuth.username];

    final jsonExerciseData = await ApiAccess.getExerciseData(authToken);
    final exerciseData =
        ApiParser.parseExercise(jsonExerciseData)[clientAuth.username];

    final jsonAnamnesisData = await ApiAccess.getAnamnesisData(authToken);
    final anamnesisData =
        ApiParser.parseAnamnesis(jsonAnamnesisData)?.values.first;

    final jsonFoodMenudata = await ApiAccess.getFoodMenudata(authToken);
    final foodMenuData =
        ApiParser.parseFoodMenu(jsonFoodMenudata)[clientAuth.username];

    final jsonWorkoutSheetData = await ApiAccess.getWorkoutSheetData(authToken);
    final workoutSheetData =
        ApiParser.parseWorkoutSheet(jsonWorkoutSheetData)[clientAuth.username];

    final jsonRelationshipData = await ApiAccess.getRelationshipData(authToken);
    final relationship = ApiParser.parsePatientRelationship(
      jsonRelationshipData,
    );

    _client = ClientPatient(
      username: clientAuth.username,
      trainer: relationship[ClientType.trainer],
      nutritionist: relationship[ClientType.nutritionist],
      weightData: weightData,
      mealData: mealData,
      exerciseData: exerciseData,
      foodMenuData: foodMenuData,
      workoutSheetData: workoutSheetData,
      anamnesis: anamnesisData,
    );
  }

  Future<void> _loadNutritionistData(ClientAuth clientAuth) async {
    final authToken = clientAuth.accessToken;

    final jsonWeightData = await ApiAccess.getWeightData(authToken);
    final weightData = ApiParser.parseWeight(jsonWeightData);

    final jsonMealData = await ApiAccess.getMealData(authToken);
    final mealData = ApiParser.parseMeal(jsonMealData);

    final jsonAnamnesisData = await ApiAccess.getAnamnesisData(authToken);
    final anamnesisData = ApiParser.parseAnamnesis(jsonAnamnesisData);

    final jsonFoodMenudata = await ApiAccess.getFoodMenudata(authToken);
    final foodMenuData = ApiParser.parseFoodMenu(jsonFoodMenudata);

    final jsonRelationshipData = await ApiAccess.getRelationshipData(authToken);
    final relationship = ApiParser.parseProfessionalRelationship(
      jsonRelationshipData,
    );

    for (final client in weightData.keys) {
      relationship?[client]?.weightData = weightData[client];
    }

    for (final client in mealData.keys) {
      relationship?[client]?.mealData = mealData[client];
    }

    if (anamnesisData != null) {
      for (final client in anamnesisData.keys) {
        relationship?[client]?.anamnesis = anamnesisData[client];
      }
    }

    for (final client in foodMenuData.keys) {
      relationship?[client]?.foodMenuData = foodMenuData[client];
    }

    _client = ClientNutritionist(
      username: clientAuth.username,
      clients: relationship,
    );

    if (relationship != null && relationship.isNotEmpty) {
      _currentPatient = relationship.values.first;
    }
  }

  Future<void> _loadTrainerData(ClientAuth clientAuth) async {
    final authToken = clientAuth.accessToken;

    final jsonWeightData = await ApiAccess.getWeightData(authToken);
    final weightData = ApiParser.parseWeight(jsonWeightData);

    final jsonExerciseData = await ApiAccess.getExerciseData(authToken);
    final exerciseData = ApiParser.parseExercise(jsonExerciseData);

    final jsonAnamnesisData = await ApiAccess.getAnamnesisData(authToken);
    final anamnesisData = ApiParser.parseAnamnesis(jsonAnamnesisData);

    final jsonWorkoutSheetData = await ApiAccess.getWorkoutSheetData(authToken);
    final workoutSheetData = ApiParser.parseWorkoutSheet(jsonWorkoutSheetData);

    final jsonRelationshipData = await ApiAccess.getRelationshipData(authToken);
    final relationship = ApiParser.parseProfessionalRelationship(
      jsonRelationshipData,
    );

    for (final client in weightData.keys) {
      relationship?[client]?.weightData = weightData[client];
    }

    for (final client in exerciseData.keys) {
      relationship?[client]?.exerciseData = exerciseData[client];
    }

    if (anamnesisData != null) {
      for (final client in anamnesisData.keys) {
        relationship?[client]?.anamnesis = anamnesisData[client];
      }
    }

    for (final client in workoutSheetData.keys) {
      relationship?[client]?.workoutSheetData = workoutSheetData[client];
    }

    _client = ClientTrainer(
      username: clientAuth.username,
      clients: relationship,
    );

    if (relationship != null && relationship.isNotEmpty) {
      _currentPatient = relationship.values.first;
    }
  }

  void switchCurrentPatient(ClientAuth clientAuth, ClientPatient? patient,){
    _currentPatient = patient;
    processCalendarData(clientAuth);
  }

  void processCalendarData(ClientAuth clientAuth) {
    _isLoading = true;
    notifyListeners();

    switch (clientAuth.clientType) {
      case ClientType.patient:
        _processPatientCalendarData();
      case ClientType.nutritionist:
        _processNutritionistCalendarData();
      case ClientType.trainer:
        _processTrainerCalendarData();
    }

    _isLoading = false;
    notifyListeners();
  }

  void _processPatientCalendarData() {
    if (_client != null) {
      _calendarData?.clear();
      _calendarData = LinkedHashMap(
        equals: isSameDay,
        hashCode: _getHashCode,
      );

      CalendarParser.addWeightDataToMap(
        _calendarData!,
        (_client as ClientPatient).weightData,
      );

      CalendarParser.addMealDataToMap(
        _calendarData!,
        (_client as ClientPatient).mealData,
      );

      CalendarParser.addExerciseDataToMap(
        _calendarData!,
        (_client as ClientPatient).exerciseData,
      );

      CalendarParser.addFoodMenuDataToMap(
        _calendarData!,
        (_client as ClientPatient).foodMenuData,
      );

      CalendarParser.addWorkoutSheetDataToMap(
        _calendarData!,
        (_client as ClientPatient).workoutSheetData,
      );

      notifyListeners();
    }
  }

  void _processNutritionistCalendarData() {
    if (_currentPatient != null) {
      _calendarData?.clear();
      _calendarData = LinkedHashMap(
        equals: isSameDay,
        hashCode: _getHashCode,
      );

      CalendarParser.addWeightDataToMap(
        _calendarData!,
        _currentPatient!.weightData,
      );

      CalendarParser.addMealDataToMap(
        _calendarData!,
        _currentPatient!.mealData,
      );

      CalendarParser.addFoodMenuDataToMap(
        _calendarData!,
        _currentPatient!.foodMenuData,
      );

      notifyListeners();
    }
  }

  void _processTrainerCalendarData() {
    if (_currentPatient != null) {
      _calendarData?.clear();
      _calendarData = LinkedHashMap(
        equals: isSameDay,
        hashCode: _getHashCode,
      );

      CalendarParser.addWeightDataToMap(
        _calendarData!,
        _currentPatient!.weightData,
      );

      CalendarParser.addExerciseDataToMap(
        _calendarData!,
        _currentPatient!.exerciseData,
      );

      CalendarParser.addWorkoutSheetDataToMap(
        _calendarData!,
        _currentPatient!.workoutSheetData,
      );

      notifyListeners();
    }
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

      final client = _client as ClientPatient;
      final weightData = WeightData(weight: weight, date: date);
      if (client.weightData != null) {
        client.weightData!.add(weightData);
      } else {
        client.weightData = [weightData];
      }

      CalendarParser.addWeightDataToMap(
        _calendarData!,
        [WeightData(weight: weight, date: date)],
      );
    } catch (e) {
      _errorMessage = 'Não foi possível enviar os dados: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> sendMeal(
    ClientAuth clientAuth,
    String description,
    DateTime date,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      ApiAccess.postMealData(
        clientAuth.accessToken,
        description,
        date,
      );

      final client = _client as ClientPatient;
      final mealData = MealData(description: description, date: date);
      if (client.mealData != null) {
        client.mealData!.add(mealData);
      } else {
        client.mealData = [mealData];
      }

      CalendarParser.addMealDataToMap(
        _calendarData!,
        [MealData(description: description, date: date)],
      );
    } catch (e) {
      _errorMessage = 'Não foi possível enviar os dados: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> sendExercise(
    ClientAuth clientAuth,
    String description,
    DateTime date,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      ApiAccess.postExerciseData(
        clientAuth.accessToken,
        description,
        date,
      );

      final client = _client as ClientPatient;
      final exerciseData = ExerciseData(description: description, date: date);
      if (client.exerciseData != null) {
        client.exerciseData!.add(exerciseData);
      } else {
        client.exerciseData = [exerciseData];
      }

      CalendarParser.addExerciseDataToMap(
        _calendarData!,
        [ExerciseData(description: description, date: date)],
      );
    } catch (e) {
      _errorMessage = 'Não foi possível enviar os dados: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> sendFoodMenu(
    ClientAuth clientAuth,
    String description,
    DateTime start,
    DateTime end,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      ApiAccess.postFoodMenuData(
        clientAuth.accessToken,
        _currentPatient!.username,
        description,
        start,
        end,
      );

      final foodMenuData = FoodMenuData(
        description: description,
        start: start,
        end: end,
      );
      if (_currentPatient!.foodMenuData != null) {
        _currentPatient!.foodMenuData!.add(foodMenuData);
      } else {
        _currentPatient!.foodMenuData = [foodMenuData];
      }

      CalendarParser.addFoodMenuDataToMap(
        _calendarData!,
        [
          FoodMenuData(
            description: description,
            start: start,
            end: end,
          )
        ],
      );
    } catch (e) {
      _errorMessage = 'Não foi possível enviar os dados: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> sendWorkoutSheet(
    ClientAuth clientAuth,
    String description,
    DateTime start,
    DateTime end,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      ApiAccess.postWorkoutSheetData(
        clientAuth.accessToken,
        _currentPatient!.username,
        description,
        start,
        end,
      );

      final workoutSheetData = WorkoutSheetData(
        description: description,
        start: start,
        end: end,
      );
      if (_currentPatient!.workoutSheetData != null) {
        _currentPatient!.workoutSheetData!.add(workoutSheetData);
      } else {
        _currentPatient!.workoutSheetData = [workoutSheetData];
      }

      CalendarParser.addWorkoutSheetDataToMap(
        _calendarData!,
        [
          WorkoutSheetData(
            description: description,
            start: start,
            end: end,
          )
        ],
      );
    } catch (e) {
      _errorMessage = 'Não foi possível enviar os dados: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> sendAnamnesis(
    ClientAuth clientAuth,
    int age,
    double height,
    double initialWeight,
    String allergies,
    String goal,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      ApiAccess.postAnamnesisData(
        clientAuth.accessToken,
        age,
        height,
        initialWeight,
        allergies,
        goal,
      );

      (_client as ClientPatient).anamnesis = Anamnesis(
        age: age,
        height: height,
        initialWeight: initialWeight,
        allergies: allergies,
        goal: goal,
      );
    } catch (e) {
      _errorMessage = 'Não foi possível enviar os dados: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> sendRelationship(ClientAuth clientAuth, String username) async {
    _isLoading = true;
    notifyListeners();

    try {
      await ApiAccess.postRelationshipData(clientAuth.accessToken, username);
    } catch (e) {
      _errorMessage = 'Não foi possível adicionar usuário: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  void cleanData() {
    _client = null;
    _calendarData = null;
    notifyListeners();
  }
}

int _getHashCode(DateTime key) =>
    key.day * 1000000 + key.month * 10000 + key.year;
