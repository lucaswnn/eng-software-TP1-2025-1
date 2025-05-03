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

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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

  List<DropdownMenu<String>>? _dropDownBuilder(
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
            dataState.currentPatient = professional.clients![val];
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

    final dataState = context.read<DataProvider>();
    Client professional = dataState.client!;

    HomeScreenContentInterface body;
    switch (authType) {
      case ClientType.trainer:
        body = HomeScreenTrainer();
        break;
      case ClientType.nutritionist:
        body = HomeScreenNutritionist();
        break;
      case ClientType.patient:
        body = HomeScreenPatient();
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
                dataState,
                professional as ClientProfessional,
              )
            : null,
      ),
      body: body,
    );
  }
}
