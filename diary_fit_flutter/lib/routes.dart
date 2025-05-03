import 'package:diary_fit/screens/home_screen_patient/anamnesis_patient_screen.dart';
import 'package:diary_fit/screens/home_screen_patient/associated_professionals_screen.dart';
import 'package:diary_fit/screens/logout_screen.dart';
import 'package:diary_fit/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:diary_fit/screens/home_screen.dart';
import 'package:diary_fit/screens/login_screen.dart';
import 'package:diary_fit/utils/widgets/invalid_route.dart';
import 'package:diary_fit/values/app_routes.dart';

// Router class
class Routes {
  const Routes._(); // Private constructor to prevent instantiation

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

      case AppRoutes.register:
        return getRoute(widget: const RegisterScreen());

      case AppRoutes.anamnesis:
        return getRoute(widget: const AnamnesisScreen());

      case AppRoutes.associatedProfessionals:
        return getRoute(widget: const AssociatedProfessionalsScreen());

      case AppRoutes.logout:
        return getRoute(widget: const LogoutScreen());

      // TODO: implementar roteadores para as rotas da lista de clientes e 
      // dados gerais do cliente atual

      default:
        return getRoute(widget: const InvalidRoute());
    }
  }
}
