import 'package:diary_fit/screens/home_screen_content_interface.dart';
import 'package:diary_fit/tads/client.dart';
import 'package:flutter/material.dart';

class HomeScreenNutritionist extends HomeScreenContentInterface {
  const HomeScreenNutritionist({super.key});

  @override
  ClientType get clientType => ClientType.nutritionist;

  @override
  String get title => 'Nutritionist Home';

  final _mainPageDestination = const NavigationRailDestination(
    icon: Icon(Icons.food_bank),
    label: Text('Nutrition'),
  );

  final _clientStatisticsDestination = const NavigationRailDestination(
    icon: Icon(Icons.fitness_center),
    label: Text('Fitness'),
  );

  final _mainPage = const Expanded(
      child: Align(alignment: Alignment.topRight, child: Text('Nutritionist')));

  final _clientStatistics = const Text('teste');

  @override
  Map<NavigationRailDestination, Widget> get contents => {
        _mainPageDestination: _mainPage,
        _clientStatisticsDestination: _clientStatistics,
      };
}
