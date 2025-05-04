import 'package:diary_fit/screens/home_screen_content_interface.dart';
import 'package:diary_fit/screens/home_screen_trainer/trainer_calendar.dart';
import 'package:diary_fit/tads/client.dart';
import 'package:diary_fit/utils/navigation_helper.dart';
import 'package:diary_fit/values/app_routes.dart';
import 'package:flutter/material.dart';

class HomeScreenTrainer extends HomeScreenContentInterface {
  const HomeScreenTrainer({super.key});

  @override
  ClientType get clientType => ClientType.trainer;

  @override
  String get title => 'Trainer Home';

  // NavigationRail destinations
  final _mainPageDestination = const NavigationRailDestination(
    icon: Icon(Icons.fitness_center),
    label: Text('Workouts'),
  );

  final _trainerOptionsDestination = const NavigationRailDestination(
    icon: Icon(Icons.directions_run),
    label: Text('Trainer Options'),
  );

  final _settingsDestination = const NavigationRailDestination(
    icon: Icon(Icons.settings),
    label: Text('Settings'),
  );

  // Content for each destination
  final _mainPage = const TrainerCalendar();
  final _trainerOptions = const _TrainerOptions();
  final _settingsPage = const _SettingsPage();

  @override
  Map<NavigationRailDestination, Widget> get contents => {
        _mainPageDestination: _mainPage,
        _trainerOptionsDestination: _trainerOptions,
        _settingsDestination: _settingsPage,
      };
}

class _TrainerOptions extends StatelessWidget {
  const _TrainerOptions();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('My Clients'),
            subtitle: const Text('List of registered clients'),
            onTap: () => NavigationHelper.pushNamed(AppRoutes.clientList),
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Add Client'),
            subtitle: const Text('Add a new client to your list'),
            onTap: () => NavigationHelper.pushNamed(AppRoutes.addClient),
          ),
          ListTile(
            leading: const Icon(Icons.assignment),
            title: const Text('Add Workout Plan'),
            subtitle: const Text('Add a workout plan for your current client'),
            onTap: () => NavigationHelper.pushNamed(AppRoutes.addWorkoutSheet),
          ),
        ],
      ),
    );
  }
}

class _SettingsPage extends StatelessWidget {
  const _SettingsPage();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          ListTile(
            leading: const Icon(Icons.power_settings_new),
            title: const Text('Logout'),
            onTap: () => NavigationHelper.pushNamed(AppRoutes.logout),
          ),
        ],
      ),
    );
  }
}
