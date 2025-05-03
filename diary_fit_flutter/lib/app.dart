import 'package:diary_fit/utils/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:diary_fit/routes.dart';
import 'package:diary_fit/utils/navigation_helper.dart';
import 'package:diary_fit/values/app_routes.dart';

// App base builder
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.login,
      navigatorKey: NavigationHelper.key,
      scaffoldMessengerKey: SnackbarHelper.key,
      onGenerateRoute: Routes.generateRoute,
    );
  }
}
