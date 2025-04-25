import 'package:diary_fit/services/auth_provider.dart';
import 'package:diary_fit/utils/snackbar_helper.dart';
import 'package:diary_fit/values/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:diary_fit/utils/navigation_helper.dart';
import 'package:diary_fit/values/app_routes.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > 350) {
        return const LoginScreenWeb();
      } else {
        return const LoginScreenMobile();
      }
    });
  }
}

class LoginScreenWeb extends StatelessWidget {
  const LoginScreenWeb({super.key});

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
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Diary Fit',
                        style: TextStyle(fontSize: 30),
                      ),
                      SizedBox(height: 20),
                      LoginForm()
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}

class LoginScreenMobile extends StatelessWidget {
  const LoginScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Diary Fit',
                    style: TextStyle(fontSize: 30),
                  ),
                  SizedBox(height: 20),
                  LoginForm(),
                ],
              ),
            ),
          ),
        ));
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              icon: Icon(Icons.person),
              labelText: 'E-mail',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira um e-mail válido.';
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
              labelText: 'Senha',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira a senha.';
              }
              return null;
            },
          ),
          const SizedBox(height: 5),
          TextButton(
            onPressed: () =>
                NavigationHelper.pushReplacementNamed(AppRoutes.register),
            child: const Text('Novo por aqui? Cadastre-se!'),
          ),
          const SizedBox(height: 30),
          if (isAuthLoading)
            const CircularProgressIndicator()
          else
            ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await authState.authenticate(
                      _emailController.text,
                      _passwordController.text,
                    );

                    if (authState.isAuthenticated) {
                      NavigationHelper.pushReplacementNamed(AppRoutes.home);
                    } else {
                      SnackbarHelper.showSnackBar(AppStrings.loginServerError);
                    }
                  }
                },
                child: const Text('Entrar')),
        ],
      ),
    );
  }
}
