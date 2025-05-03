import 'package:diary_fit/services/auth_provider.dart';
import 'package:diary_fit/services/data_provider.dart';
import 'package:diary_fit/tads/client.dart';
import 'package:diary_fit/utils/navigation_helper.dart';
import 'package:diary_fit/utils/snackbar_helper.dart';
import 'package:diary_fit/utils/widgets/web_layout_constrained_box.dart';
import 'package:diary_fit/values/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnamnesisScreen extends StatelessWidget {
  const AnamnesisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final client = context.read<DataProvider>().client! as ClientPatient;
    final anamnesis = client.anamnesis;

    if (anamnesis == null) {
      return const _AnamnesisForm();
    }
    return const _AnamnesisSheet();
  }
}

class _AnamnesisSheet extends StatelessWidget {
  const _AnamnesisSheet();

  @override
  Widget build(BuildContext context) {
    final client = context.read<DataProvider>().client! as ClientPatient;
    final anamnesis = client.anamnesis!.anamnesisDataMap;

    final anamnesisLabels = anamnesis.keys.toList();
    final anamnesisContent = anamnesis.values.toList();

    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
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

class _AnamnesisForm extends StatefulWidget {
  const _AnamnesisForm();

  @override
  State<_AnamnesisForm> createState() => _AnamnesisFormState();
}

class _AnamnesisFormState extends State<_AnamnesisForm> {
  final _formKey = GlobalKey<FormState>();

  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _allergiesController = TextEditingController();
  final _goalController = TextEditingController();

  @override
  void dispose() {
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _allergiesController.dispose();
    _goalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthProvider>();
    final dataState = context.watch<DataProvider>();

    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: const Text('Preencha sua ficha anamnese'),
      ),
      body: Center(
        child: WebLayoutConstrainedBox(
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
                      controller: _ageController,
                      decoration: const InputDecoration(
                        labelText: AppStrings.anamnesisAgeLabel,
                      ),
                      validator: (value) {
                        if (value == null || int.tryParse(value) == null) {
                          return AppStrings.anamnesisInvalidAgeMessage;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: _heightController,
                      decoration: const InputDecoration(
                        labelText: AppStrings.anamnesisHeightLabel,
                      ),
                      validator: (value) {
                        if (value == null || double.tryParse(value) == null) {
                          return AppStrings.anamnesisInvalidHeightMessage;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: _weightController,
                      decoration: const InputDecoration(
                        labelText: AppStrings.anamnesisWeightLabel,
                      ),
                      validator: (value) {
                        if (value == null || double.tryParse(value) == null) {
                          return AppStrings.anamnesisInvalidWeightMessage;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: _allergiesController,
                      decoration: const InputDecoration(
                        labelText: AppStrings.anamnesisAllergiesLabel,
                      ),
                      validator: (value) {
                        if (value == null) {
                          return AppStrings.anamnesisInvalidAllergiesMessage;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: _goalController,
                      decoration: const InputDecoration(
                        labelText: AppStrings.anamnesisGoalLabel,
                      ),
                      validator: (value) {
                        if (value == null) {
                          return AppStrings.anamnesisInvalidGoalMessage;
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
                            dataState.sendAnamnesis(
                              authState.clientAuth!,
                              dataState.client as ClientPatient,
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
                        child: const Text(AppStrings.anamnesisSubmitButton),
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
