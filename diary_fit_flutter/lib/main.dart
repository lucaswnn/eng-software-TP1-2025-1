import 'package:diary_fit/services/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:diary_fit/app.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

void main() async {
  await initializeDateFormatting();
  Intl.defaultLocale = 'pt_BR';
  runApp(ChangeNotifierProvider(
    create: (_) => AuthProvider(),
    child: const MyApp(),
  ));
}
