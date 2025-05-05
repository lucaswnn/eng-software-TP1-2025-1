import 'package:diary_fit/screens/home_screen_content_interface.dart';
import 'package:diary_fit/screens/home_screen_nutritionist/home_screen_nutritionist.dart';
import 'package:diary_fit/screens/home_screen_patient/home_screen_patient.dart';
import 'package:diary_fit/screens/home_screen_trainer/home_screen_trainer.dart';
import 'package:diary_fit/services/auth_provider.dart';
import 'package:diary_fit/services/data_provider.dart';
import 'package:diary_fit/tads/client.dart';
import 'package:diary_fit/utils/widgets/invalid_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Main class for home UI
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // This method is called only if professionals are logged in
  // Returns the clients options
  List<DropdownMenuEntry<String>> _clientEntriesBuilder(
      ClientProfessional professional) {
    final clients = professional.clients?.keys.toList() ?? [];
    return clients
        .map((v) => DropdownMenuEntry<String>(
              value: v,
              label: v,
            ))
        .toList();
  }

  // Builds the DropDownMenu
  // The widget is wrapped in a list to directly return to the appBar actions
  List<DropdownMenu<String>>? _dropDownBuilder(
    AuthProvider authState,
    DataProvider dataState,
    ClientProfessional professional,
  ) {
    if (professional.clients != null && professional.clients!.isNotEmpty) {
      return [
        DropdownMenu<String>(
          menuStyle: const MenuStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.white),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          initialSelection: dataState.currentPatient!.username,
          dropdownMenuEntries: _clientEntriesBuilder(professional),
          onSelected: (val) {
            dataState.switchCurrentPatient(
                authState.clientAuth!, professional.clients![val]);
          },
        )
      ];
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthProvider>();
    if (!authState.isAuthenticated) {
      return const InvalidRoute();
    }

    final clientAuth = authState.clientAuth!;
    final authType = clientAuth.clientType;

    final dataState = context.watch<DataProvider>();
    Client professional = dataState.client!;

    HomeScreenContentInterface body;
    switch (authType) {
      case ClientType.trainer:
        body = const HomeScreenTrainer();
        break;
      case ClientType.nutritionist:
        body = const HomeScreenNutritionist();
        break;
      case ClientType.patient:
        body = const HomeScreenPatient();
        break;
    }

    final title = body.title;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
        title: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        actions: authType != ClientType.patient
            ? _dropDownBuilder(
                authState,
                dataState,
                professional as ClientProfessional,
              )
            : null,
      ),
      body: body,
    );
  }
}
