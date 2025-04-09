import 'package:flutter/material.dart';
import 'package:flutter_app/routes.dart';
import 'package:flutter_app/utils/navigation_helper.dart';
import 'package:flutter_app/values/app_routes.dart';

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