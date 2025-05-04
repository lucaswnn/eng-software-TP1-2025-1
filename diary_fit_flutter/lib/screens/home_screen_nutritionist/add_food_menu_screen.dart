import 'package:diary_fit/services/auth_provider.dart';
import 'package:diary_fit/services/data_provider.dart';
import 'package:diary_fit/utils/navigation_helper.dart';
import 'package:diary_fit/utils/snackbar_helper.dart';
import 'package:diary_fit/utils/widgets/web_layout_constrained_box.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddFoodMenuScreen extends StatefulWidget {
  const AddFoodMenuScreen({super.key});

  @override
  State<AddFoodMenuScreen> createState() => _AddFoodMenuScreenState();
}

class _AddFoodMenuScreenState extends State<AddFoodMenuScreen> {
  final _formKey = GlobalKey<FormState>();

  final _descriptionController = TextEditingController();
  final _firstDayController = TextEditingController();
  final _lastDayController = TextEditingController();

  DateTime? _firstDay;
  DateTime? _lastDay;

  @override
  void initState() {
    super.initState();

    _firstDay = DateTime.now();
    _lastDay = _firstDay!.add(const Duration(days: 1));
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _firstDayController.dispose();
    _lastDayController.dispose();
    super.dispose();
  }

  Future<void> _selectFirstDate() async {
    DateTime? picked = await showDatePicker(
      helpText: 'Data inicial',
      cancelText: 'Cancelar',
      context: context,
      initialDate: _firstDay,
      firstDate: DateTime(2025),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        _firstDayController.text =
            '${picked.day}/${picked.month}/${picked.year}';
        _firstDay = picked;
      });
    }
  }

  Future<void> _selectLastDate() async {
    DateTime? picked = await showDatePicker(
      helpText: 'Data final',
      cancelText: 'Cancelar',
      context: context,
      initialDate: _lastDay,
      firstDate: DateTime(2025),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        _lastDayController.text =
            '${picked.day}/${picked.month}/${picked.year}';
        _lastDay = picked;
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
        // TODO: colocar string no AppStrings
        title: const Text('Adicione um cardápio ao usuário corrente'),
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
                        hintText: 'Digite a descrição do cardápio...',
                      ),
                      validator: (value) {
                        if (value == null) {
                          return 'insira um nome válido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 25),
                    TextFormField(
                      controller: _firstDayController,
                      decoration: const InputDecoration(
                        filled: true,
                        labelText: 'Data inicial',
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      readOnly: true,
                      onTap: () => _selectFirstDate(),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _lastDayController,
                      decoration: const InputDecoration(
                        filled: true,
                        labelText: 'Data final',
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      readOnly: true,
                      onTap: () => _selectLastDate(),
                    ),
                    const SizedBox(height: 30),
                    if (dataState.isLoading)
                      const CircularProgressIndicator()
                    else
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            dataState.sendFoodMenu(
                              authState.clientAuth!,
                              _descriptionController.text,
                              _firstDay!,
                              _lastDay!,
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
