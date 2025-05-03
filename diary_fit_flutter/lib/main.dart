import 'package:diary_fit/services/auth_provider.dart';
import 'package:diary_fit/services/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:diary_fit/app.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

void main() async {
  await initializeDateFormatting();

  // Defines the default locale for table_calendar
  Intl.defaultLocale = 'pt_BR';

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
        ChangeNotifierProvider<DataProvider>(create: (_) => DataProvider()),
      ],
      child: const MyApp(),
    ),
  );
}
