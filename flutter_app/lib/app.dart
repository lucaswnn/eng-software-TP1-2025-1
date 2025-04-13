import 'package:flutter/material.dart';
import 'package:diary_fit/routes.dart';
import 'package:diary_fit/utils/navigation_helper.dart';
import 'package:diary_fit/values/app_routes.dart';

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: AppRoutes.login,
          navigatorKey: NavigationHelper.key,
          onGenerateRoute: Routes.generateRoute,
        );
  }
}