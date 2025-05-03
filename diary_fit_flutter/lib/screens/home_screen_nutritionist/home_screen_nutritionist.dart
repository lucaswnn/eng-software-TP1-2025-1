import 'package:diary_fit/screens/home_screen_content_interface.dart';
import 'package:diary_fit/tads/client.dart';
import 'package:diary_fit/utils/navigation_helper.dart';
import 'package:diary_fit/values/app_routes.dart';
import 'package:diary_fit/values/app_strings.dart';
import 'package:flutter/material.dart';

class HomeScreenNutritionist extends HomeScreenContentInterface {
  HomeScreenNutritionist({super.key});

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

  final _settingsDestination = const NavigationRailDestination(
    icon: Icon(Icons.settings),
    label: Text(AppStrings.homePageSettingsNavLabel),
  );

  final _mainPage = const Expanded(
      child: Align(alignment: Alignment.topRight, child: Text('Nutritionist')));

  final _clientStatistics = const Text('teste');

  final _settingsPage = Expanded(
    child: ListView(
      padding: const EdgeInsets.all(8.0),
      children: [
        ListTile(
          leading: const Icon(Icons.power_settings_new),
          title: const Text('Fazer logout'),
          onTap: () => NavigationHelper.pushNamed(AppRoutes.logout),
        )
      ],
    ),
  );

  @override
  Map<NavigationRailDestination, Widget> get contents => {
        _mainPageDestination: _mainPage,
        _clientStatisticsDestination: _clientStatistics,
        _settingsDestination: _settingsPage,
      };
}
