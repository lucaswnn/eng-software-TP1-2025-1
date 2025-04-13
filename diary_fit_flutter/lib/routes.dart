import 'package:flutter/material.dart';
import 'package:diary_fit/screens/home_screen.dart';
import 'package:diary_fit/screens/login_screen.dart';
import 'package:diary_fit/utils/invalid_route.dart';
import 'package:diary_fit/values/app_routes.dart';

class Routes {
  const Routes._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    Route<dynamic> getRoute({
      required Widget widget,
      bool fullscreenDialog = false,
    }) {
      return MaterialPageRoute<void>(
        builder: (context) => widget,
        settings: settings,
        fullscreenDialog: fullscreenDialog,
      );
    }

    switch (settings.name) {
      case AppRoutes.login:
        return getRoute(widget: const LoginScreen());

      case AppRoutes.home:
        return getRoute(widget: const HomeScreen());

      default:
        return getRoute(widget: const InvalidRoute());
    }
  }
}
