import 'package:flutter/material.dart';

class SnackbarHelper {
  const SnackbarHelper._();

  static final _key = GlobalKey<ScaffoldMessengerState>();

  static GlobalKey<ScaffoldMessengerState> get key => _key;

  static void showSnackBar(String? message) {
    _key.currentState
      ?..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message ?? ''),
        ),
      );
  }
}
