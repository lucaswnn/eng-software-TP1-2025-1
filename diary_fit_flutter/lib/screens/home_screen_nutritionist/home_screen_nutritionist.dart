import 'package:diary_fit/screens/home_screen_content_interface.dart';
import 'package:diary_fit/screens/home_screen_nutritionist/nutritionist_calendar.dart';
import 'package:diary_fit/tads/client.dart';
import 'package:diary_fit/utils/navigation_helper.dart';
import 'package:diary_fit/values/app_routes.dart';
import 'package:diary_fit/values/app_strings.dart';
import 'package:flutter/material.dart';

// Class responsible for nutritionist UI homepage
class HomeScreenNutritionist extends HomeScreenContentInterface {
  const HomeScreenNutritionist({super.key});

  @override
  ClientType get clientType => ClientType.nutritionist;

  // Title appears at home AppBar
  @override
  String get title => 'Diary Fit Home';

  // The following widgets are NavigationRail destinations

  final _mainPageDestination = const NavigationRailDestination(
    icon: Icon(Icons.food_bank),
    label: Text('Nutrition'),
  );

  final _nutritionistOptionsDestination = const NavigationRailDestination(
    icon: Icon(Icons.restaurant),
    label: Text('Fitness'),
  );

  final _settingsDestination = const NavigationRailDestination(
    icon: Icon(Icons.settings),
    label: Text(AppStrings.homePageSettingsNavLabel),
  );

  // The following widgets are the content based on the
  // current selected NavigationRail destination

  final _mainPage = const NutritionistCalendar();
  final _nutritionistOptions = const _NutritionistOptions();
  final _settingsPage = const _SettingsPage();

  @override
  Map<NavigationRailDestination, Widget> get contents => {
        _mainPageDestination: _mainPage,
        _nutritionistOptionsDestination: _nutritionistOptions,
        _settingsDestination: _settingsPage,
      };
}

class _NutritionistOptions extends StatelessWidget {
  const _NutritionistOptions();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          ListTile(
            leading: const Icon(Icons.list),
            // TODO: colocar strings no AppStrings
            title: const Text('Meus clientes'),
            subtitle: const Text('Lista de clientes cadastrados'),
            onTap: () => NavigationHelper.pushNamed(AppRoutes.clientList),
          ),
          ListTile(
            leading: const Icon(Icons.add),
            // TODO: colocar strings no AppStrings
            title: const Text('Adicionar cliente'),
            subtitle: const Text('Adicione um cliente para sua lista'),
            onTap: () =>
                NavigationHelper.pushNamed(AppRoutes.addClient),
          ),
          ListTile(
            leading: const Icon(Icons.restaurant),
            // TODO: colocar strings no AppStrings
            title: const Text('Adicionar cardápio'),
            subtitle: const Text('Adicione um cardápio para seu cliente atual'),
            onTap: () =>
                NavigationHelper.pushNamed(AppRoutes.addFoodMenu),
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
            // TODO: colocar string no AppStrings
            title: const Text('Fazer logout'),
            onTap: () => NavigationHelper.pushNamed(AppRoutes.logout),
          )
        ],
      ),
    );
  }
}
