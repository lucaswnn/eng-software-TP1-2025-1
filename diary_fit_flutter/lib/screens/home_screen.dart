import 'package:diary_fit/screens/home_screen_content_interface.dart';
import 'package:diary_fit/screens/home_screen_nutritionist.dart';
import 'package:diary_fit/screens/home_screen_patient.dart';
import 'package:diary_fit/screens/home_screen_trainer.dart';
import 'package:diary_fit/services/client_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = ClientAuth();
    final authType = auth.getAuthType();
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
