import 'package:diary_fit/services/auth_provider.dart';
import 'package:diary_fit/services/client_auth.dart';
import 'package:diary_fit/utils/snackbar_helper.dart';
import 'package:diary_fit/values/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:diary_fit/utils/navigation_helper.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > 350) {
        return const RegisterScreenWeb();
      } else {
        return const RegisterScreenMobile();
      }
    });
  }
}

class RegisterScreenWeb extends StatelessWidget {
  const RegisterScreenWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue,
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 300,
                maxHeight: 500,
              ),
              child: const Card(
                child: CommonRegisterContent(),
              ),
            ),
          ),
        ));
  }
}

class RegisterScreenMobile extends StatelessWidget {
  const RegisterScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Center(
            child: CommonRegisterContent(),
          ),
        ));
  }
}

class CommonRegisterContent extends StatelessWidget {
  const CommonRegisterContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () {
                    NavigationHelper.pop();
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
              ),
              const Align(
                alignment: Alignment.center,
                child: Text(AppStrings.registerTitle,
                    style: TextStyle(fontSize: 30)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const RegisterForm(),
        ],
      ),
    );
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  ClientType _clientType = ClientType.patient;

  final _registerOptions = [
    DropdownMenuItem(
      value: ClientType.trainer,
      child: Text(AppStrings.trainerLabel),
    ),
    DropdownMenuItem(
      value: ClientType.nutritionist,
      child: Text(AppStrings.nutritionistLabel),
    ),
    DropdownMenuItem(
      value: ClientType.patient,
      child: Text(AppStrings.patientLabel),
    ),
  ];

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthProvider>();
    final isAuthLoading = authState.isLoading;

    return Form(
      key: _formKey,
      child: Column(
        children: [
          DropdownButtonFormField(
            items: _registerOptions,
            value: ClientType.patient,
            onChanged: (val) => setState(() => _clientType = val!),
            icon: const Icon(Icons.arrow_drop_down),
            decoration: const InputDecoration(
              labelText: AppStrings.registerTypeLabel,
            ),
          ),
          const SizedBox(height: 5),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              icon: Icon(Icons.person),
              labelText: AppStrings.loginLabel,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppStrings.invalidLoginMessage;
              }
              return null;
            },
          ),
          const SizedBox(height: 5),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              icon: Icon(Icons.lock),
              labelText: AppStrings.passwordLabel,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppStrings.invalidPasswordMessage;
              }
              return null;
            },
          ),
          const SizedBox(height: 5),
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: true,
            decoration: const InputDecoration(
              icon: Icon(Icons.check),
              labelText: AppStrings.confirmPasswordLabel,
            ),
            validator: (value) {
              if (value != _passwordController.text) {
                return AppStrings.invalidConfirmPasswordMessage;
              }
              return null;
            },
          ),
          const SizedBox(height: 30),
          if (isAuthLoading)
            const CircularProgressIndicator()
          else
            ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await authState.register(
                      _emailController.text,
                      _passwordController.text,
                      _clientType,
                    );

                    String? message = authState.registerErrorMessage;
                    if (message == null) {
                      message = AppStrings.successRegisterMessage;
                      SnackbarHelper.showSnackBar(message);
                      NavigationHelper.pop();
                    } else {
                      message = AppStrings.genericServerError;
                      SnackbarHelper.showSnackBar('$message\n${authState.registerErrorMessage}');
                    }
                  }
                },
                child: const Text(AppStrings.loginButton)),
        ],
      ),
    );
  }
}
