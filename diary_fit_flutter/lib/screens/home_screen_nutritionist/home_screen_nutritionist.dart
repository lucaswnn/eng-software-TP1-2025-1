import 'package:diary_fit/screens/home_screen_content_interface.dart';
import 'package:diary_fit/tads/client.dart';
import 'package:diary_fit/utils/navigation_helper.dart';
import 'package:diary_fit/values/app_routes.dart';
import 'package:diary_fit/values/app_strings.dart';
import 'package:flutter/material.dart';

// Class responsible for nutritionist UI homepage
class HomeScreenNutritionist extends HomeScreenContentInterface {
  HomeScreenNutritionist({super.key});

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

  // TODO: escolher um ícone melhor
  final _clientStatisticsDestination = const NavigationRailDestination(
    icon: Icon(Icons.fitness_center),
    label: Text('Fitness'),
  );

  final _settingsDestination = const NavigationRailDestination(
    icon: Icon(Icons.settings),
    label: Text(AppStrings.homePageSettingsNavLabel),
  );

  // The following widgets are the content based on the
  // current selected NavigationRail destination

  // TODO: implementar página inicial do nutricionista
  // A ideia seria colocar também um calendário com os dados inseridos
  // pelo usuário corrente e também as fichas e cardápios
  // Recomendo seguir a mesma ideia da classe HomeScreenPatient
  final _mainPage = const Expanded(
      child: Align(alignment: Alignment.topRight, child: Text('Nutritionist')));

  // TODO: implementar página com algumas opções (semelhante ao HomeScreenPatient)
  // As escolhas estão em aberto, mas recomendo uma página com a lista de clientes,
  // e uma página para dados básicos do cliente corrente
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
