import 'package:diary_fit/screens/home_screen_content_interface.dart';
import 'package:diary_fit/tads/client.dart';
import 'package:flutter/material.dart';

class HomeScreenTrainer extends HomeScreenContentInterface {
  const HomeScreenTrainer({super.key});

  @override
  ClientType get clientType => ClientType.nutritionist;

  @override
  String get title => 'Trainer Home';

  final List<NavigationRailDestination> _destinations = const [
    NavigationRailDestination(
      icon: Icon(Icons.food_bank),
      label: Text('Trainer'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.fitness_center),
      label: Text('Exercises'),
    ),
  ];

  final List<Widget> _contents = const [
    Expanded(child: Center(child: Text('Trainer Content'))),
    Expanded(child: Center(child: Text('Exercises Content'))),
  ];

  @override
  Map<NavigationRailDestination, Widget> get contents =>
      Map.fromIterables(_destinations, _contents);
}
