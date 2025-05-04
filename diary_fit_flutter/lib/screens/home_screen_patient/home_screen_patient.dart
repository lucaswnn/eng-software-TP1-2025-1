import 'package:diary_fit/screens/home_screen_content_interface.dart';
import 'package:diary_fit/screens/home_screen_patient/patient_calendar.dart';
import 'package:diary_fit/tads/client.dart';
import 'package:diary_fit/utils/navigation_helper.dart';
import 'package:diary_fit/values/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:diary_fit/values/app_strings.dart';

// Class responsible for patient UI homepage
class HomeScreenPatient extends HomeScreenContentInterface {
  const HomeScreenPatient({super.key});

  @override
  ClientType get clientType => ClientType.patient;

  // title appears at home AppBar
  @override
  String get title => 'Diary Fit Home';

  // The following widgets are NavigationRail destinations

  final _calendarDestination = const NavigationRailDestination(
    icon: Icon(Icons.calendar_today),
    label: Text(AppStrings.patientScreenCalendarNavLabel),
  );

  final _userDestination = const NavigationRailDestination(
    icon: Icon(Icons.person),
    label: Text(AppStrings.patientScreenUserNavLabel),
  );

  final _settingsDestination = const NavigationRailDestination(
    icon: Icon(Icons.settings),
    label: Text(AppStrings.homePageSettingsNavLabel),
  );

  // The following widgets are the content based on the
  // current selected NavigationRail destination

  final _calendarPage = const PatientCalendar();
  final _userPage = const _UserPage();
  final _settingsPage = const _SettingsPage();

  @override
  Map<NavigationRailDestination, Widget> get contents => {
        _calendarDestination: _calendarPage,
        _userDestination: _userPage,
        _settingsDestination: _settingsPage,
      };
}

class _UserPage extends StatelessWidget {
  const _UserPage();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          ListTile(
            leading: const Icon(Icons.list),
            // TODO: colocar strings no AppStrings
            title: const Text('Ficha anamnese'),
            subtitle: const Text('Dados para consulta de especialistas'),
            onTap: () => NavigationHelper.pushNamed(AppRoutes.anamnesis),
          ),
          ListTile(
            leading: const Icon(Icons.people),
            // TODO: colocar strings no AppStrings
            title: const Text('Profissionais'),
            subtitle: const Text('Treinadores e nutricionistas associados'),
            onTap: () =>
                NavigationHelper.pushNamed(AppRoutes.associatedProfessionals),
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
