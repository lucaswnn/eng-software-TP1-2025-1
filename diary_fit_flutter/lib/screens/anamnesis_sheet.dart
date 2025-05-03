import 'package:diary_fit/services/data_provider.dart';
import 'package:diary_fit/tads/client.dart';
import 'package:diary_fit/utils/widgets/web_layout_constrained_box.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Anamnesis sheet UI
class AnamnesisSheet extends StatelessWidget {
  const AnamnesisSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final client = context.read<DataProvider>().client! as ClientPatient;
    final anamnesis = client.anamnesis!.anamnesisDataMap;

    final anamnesisLabels = anamnesis.keys.toList();
    final anamnesisContent = anamnesis.values.toList();

    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        // TODO: adicionar string para AppStrings
        title: const Text('Ficha Anamnese'),
      ),
      body: Center(
        child: WebLayoutConstrainedBox(
          child: Card(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: anamnesisLabels.length,
              itemBuilder: (_, index) {
                return ListTile(
                  // TODO opcional: estilizar fonte
                  title: Text(anamnesisLabels[index]),
                  trailing: Text('${anamnesisContent[index]}'),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}