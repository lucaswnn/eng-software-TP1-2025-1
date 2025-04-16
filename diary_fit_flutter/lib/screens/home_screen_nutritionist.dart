import 'package:diary_fit/screens/home_screen_content_interface.dart';
import 'package:diary_fit/services/client_auth.dart';
import 'package:flutter/material.dart';

class HomeScreenNutritionist extends HomeScreenContentInterface {
  const HomeScreenNutritionist({super.key});

  @override
  ClientType get clientType => ClientType.nutritionist;

  @override
  String get title => 'Nutritionist Home';

  final List<NavigationRailDestination> _destinations = const [
    NavigationRailDestination(
      icon: Icon(Icons.food_bank),
      label: Text('Nutrition'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.fitness_center),
      label: Text('Fitness'),
    ),
  ];

  final List<Widget> _contents = const [
    Expanded(child: Center(child: Text('Nutrition Content'))),
    Expanded(child: Center(child: Text('Fitness Content'))),
  ];

  @override
  Map<NavigationRailDestination, Widget> get contents =>
      Map.fromIterables(_destinations, _contents);
}
