import 'package:flutter/material.dart';
import 'package:diary_fit/utils/navigation_helper.dart';
import 'package:diary_fit/values/app_routes.dart';

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
    return Material(
        color: Colors.blue,
        child: Padding(
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
    return const Material(
        color: Colors.white,
        child: Padding(
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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
              icon: Icon(Icons.person),
              labelText: 'E-mail',
            ),
          ),
          const SizedBox(height: 5),
          TextFormField(
            obscureText: true,
            decoration: const InputDecoration(
              icon: Icon(Icons.lock),
              labelText: 'Senha',
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
              onPressed: () =>
                  NavigationHelper.pushReplacementNamed(AppRoutes.home),
              child: const Text('Entrar')),
        ],
      ),
    );
  }
}
