import 'package:diary_fit/screens/home_screen_content_interface.dart';
import 'package:diary_fit/services/client_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeScreenPatient extends HomeScreenContentInterface {
  HomeScreenPatient({super.key});

  @override
  ClientType get clientType => ClientType.patient;

  @override
  String get title => 'Patient Home';

  final List<NavigationRailDestination> _destinations = const [
    NavigationRailDestination(
      icon: Icon(Icons.calendar_today),
      label: Text('Calendar'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.fitness_center),
      label: Text('Fitness'),
    ),
  ];

  List<Widget> get _contents => [
        _calendarContent,
        const Expanded(child: Center(child: Text('Fitness Content'))),
      ];

  final Widget _calendarContent = Flexible(
    child: TableCalendar(
      firstDay: DateTime.utc(2010, 10, 16),
      lastDay: DateTime.utc(2030, 3, 14),
      focusedDay: DateTime.now(),
      calendarFormat: CalendarFormat.month,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      daysOfWeekVisible: true,
      onFormatChanged: (format) {
        // Handle format change
      },
      onPageChanged: (focusedDay) {
        // Handle page change
      },
      calendarStyle: const CalendarStyle(
        isTodayHighlighted: true,
        selectedDecoration: BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
        ),
        todayDecoration: BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
      ),
    ),
  );

  @override
  Map<NavigationRailDestination, Widget> get contents =>
      Map.fromIterables(_destinations, _contents);
}
