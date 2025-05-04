import 'package:diary_fit/services/data_provider.dart';
import 'package:diary_fit/tads/client.dart';
import 'package:diary_fit/utils/widgets/web_layout_constrained_box.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Client list UI
class ClientListScreen extends StatelessWidget {
  const ClientListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final professional = context.select(
      (DataProvider dataState) => dataState.client,
    ) as ClientProfessional;
    
    final clients = professional.clients ?? {};
    final clientsUsername = clients.keys.toList();
    final clientsContent = clients.values.toList();

    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        // TODO: adicionar string para AppStrings
        title: const Text('Lista de usuários'),
      ),
      body: Center(
        child: WebLayoutConstrainedBox(
          child: Card(
            child: ListView.builder(
              itemCount: clientsUsername.length,
              itemBuilder: (_, index) {
                return ListTile(
                  // TODO opcional: estilizar fonte
                  title: Text(clientsUsername[index]),
                  trailing: Text('${clientsContent[index].anamnesis}'),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
