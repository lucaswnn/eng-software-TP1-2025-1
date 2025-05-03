import 'package:diary_fit/services/data_provider.dart';
import 'package:diary_fit/tads/client.dart';
import 'package:diary_fit/utils/widgets/web_layout_constrained_box.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Simple UI responsible for showing the user's porfessionals
class AssociatedProfessionalsScreen extends StatelessWidget {
  const AssociatedProfessionalsScreen({super.key});

  List<ListTile> _getProfessionals(ClientPatient client) {
    final nutritionistTile = client.nutritionist != null
        ? ListTile(
            // TODO: colocar string no AppStrings
            title: const Text('Nutricionista'),
            trailing: Text('${client.nutritionist}'),
          )
        : null;

    final trainerTile = client.trainer != null
        ? ListTile(
            // TODO: colocar string no AppStrings
            title: const Text('Educador físico'),
            trailing: Text('${client.trainer}'),
          )
        : null;

    return [
      if (nutritionistTile != null) nutritionistTile,
      if (trainerTile != null) trainerTile,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final client = context.select((DataProvider dataState) => dataState.client)
        as ClientPatient;

    final infoTile = _getProfessionals(client);

    return Scaffold(
      appBar: AppBar(
        // TODO: colocar string no AppStrings
        title: const Text('Profissionais associados'),
      ),
      backgroundColor: Colors.blue,
      body: Center(
        child: WebLayoutConstrainedBox(
          child: Card(
            child: infoTile.isEmpty
                ? const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Text(
                          // TODO: colocar string no AppStrings
                          'Parece que você ainda não tem profissionais relacionados',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ],
                  )
                : ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(8.0),
                    children: _getProfessionals(client),
                  ),
          ),
        ),
      ),
    );
  }
}
