import 'package:flutter/material.dart';
import 'package:diary_fit/app.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

void main() async {
  await initializeDateFormatting();
  Intl.defaultLocale = 'pt_BR';
  runApp(const MyApp());
}
