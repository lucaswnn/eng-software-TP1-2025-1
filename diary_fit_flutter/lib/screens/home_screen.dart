import 'package:diary_fit/screens/home_screen_content_interface.dart';
import 'package:diary_fit/screens/home_screen_nutritionist.dart';
import 'package:diary_fit/screens/home_screen_patient.dart';
import 'package:diary_fit/screens/home_screen_trainer.dart';
import 'package:diary_fit/services/auth_provider.dart';
import 'package:diary_fit/services/client_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthProvider>();
    final authType = authState.clientType;

    HomeScreenContentInterface body;
    switch (authType) {
      case ClientType.trainer:
        body = const HomeScreenTrainer();
        break;
      case ClientType.nutritionist:
        body = const HomeScreenNutritionist();
        break;
      case ClientType.patient:
        body = HomeScreenPatient();
        break;
      default:
        throw Exception('Unknown client type');
    }

    final title = body.title;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(title),
      ),
      body: body,
    );
  }
}
