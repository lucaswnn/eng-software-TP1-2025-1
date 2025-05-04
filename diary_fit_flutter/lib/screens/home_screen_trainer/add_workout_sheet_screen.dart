import 'package:diary_fit/services/auth_provider.dart';
import 'package:diary_fit/services/data_provider.dart';
import 'package:diary_fit/utils/navigation_helper.dart';
import 'package:diary_fit/utils/snackbar_helper.dart';
import 'package:diary_fit/utils/widgets/web_layout_constrained_box.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddWorkoutSheetScreen extends StatefulWidget {
  const AddWorkoutSheetScreen({super.key});

  @override
  State<AddWorkoutSheetScreen> createState() => _AddWorkoutSheetScreenState();
}

class _AddWorkoutSheetScreenState extends State<AddWorkoutSheetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _startDate = DateTime.now();
    _endDate = _startDate!.add(const Duration(days: 1));
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  Future<void> _selectStartDate() async {
    DateTime? picked = await showDatePicker(
      helpText: 'Data inicial',
      cancelText: 'Cancelar',
      context: context,
      initialDate: _startDate!,
      firstDate: DateTime(2025),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        _startDateController.text =
            '${picked.day}/${picked.month}/${picked.year}';
        _startDate = picked;
      });
    }
  }

  Future<void> _selectEndDate() async {
    DateTime? picked = await showDatePicker(
      helpText: 'Data final',
      cancelText: 'Cancelar',
      context: context,
      initialDate: _endDate!,
      firstDate: DateTime(2025),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        _endDateController.text =
            '${picked.day}/${picked.month}/${picked.year}';
        _endDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthProvider>();
    final dataState = context.watch<DataProvider>();

    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: const Text('Adicionar Ficha de Treino'),
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
                      minLines: 5,
                      maxLines: null,
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        filled: true,
                        border: OutlineInputBorder(),
                        hintText: 'Digite a descrição da ficha...',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira uma descrição válida.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 25),
                    TextFormField(
                      controller: _startDateController,
                      decoration: const InputDecoration(
                        filled: true,
                        labelText: 'Data inicial',
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      readOnly: true,
                      onTap: () => _selectStartDate(),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _endDateController,
                      decoration: const InputDecoration(
                        filled: true,
                        labelText: 'Data final',
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      readOnly: true,
                      onTap: () => _selectEndDate(),
                    ),
                    const SizedBox(height: 30),
                    if (dataState.isLoading)
                      const CircularProgressIndicator()
                    else
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            dataState.sendWorkoutSheet(
                              authState.clientAuth!,
                              _descriptionController.text,
                              _startDate!,
                              _endDate!,
                            );

                            final errorMessage = dataState.errorMessage;
                            if (errorMessage != null) {
                              SnackbarHelper.showSnackBar(errorMessage);
                            } else {
                              SnackbarHelper.showSnackBar(
                                  'Ficha adicionada com sucesso!');
                              NavigationHelper.pop();
                            }
                          }
                        },
                        child: const Text('Salvar'),
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
