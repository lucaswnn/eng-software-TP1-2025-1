import 'package:diary_fit/services/auth_provider.dart';
import 'package:diary_fit/services/data_provider.dart';
import 'package:diary_fit/utils/navigation_helper.dart';
import 'package:diary_fit/utils/snackbar_helper.dart';
import 'package:diary_fit/values/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddClientScreen extends StatefulWidget {
  const AddClientScreen({super.key});

  @override
  State<AddClientScreen> createState() => _AddClientScreenState();
}

class _AddClientScreenState extends State<AddClientScreen> {
  final _formKey = GlobalKey<FormState>();

  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthProvider>();
    final dataState = context.watch<DataProvider>();

    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        // TODO: colocar string no AppStrings
        title: const Text('Adicione um usuário a seus clientes'),
      ),
      body: Center(
        child: ConstrainedBox(constraints: BoxConstraints(maxHeight: AppSizes.maxWidthWebConstraint,maxWidth: AppSizes.maxWidthWebConstraint,),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextFormField(
                      controller: _textController,
                      decoration: const InputDecoration(
                        labelText: 'nome do usuário',
                      ),
                      validator: (value) {
                        if (value == null) {
                          return 'insira um nome válido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    if (dataState.isLoading)
                      const CircularProgressIndicator()
                    else
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            dataState.sendRelationship(
                              authState.clientAuth!,_textController.text,
                            );

                            final errorMessage = dataState.errorMessage;
                            if (errorMessage != null) {
                              SnackbarHelper.showSnackBar(errorMessage);
                            } else {
                              SnackbarHelper.showSnackBar('feito');
                              NavigationHelper.pop();
                            }
                          }
                        },
                        child: const Text('enviar'),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
