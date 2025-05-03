import 'package:diary_fit/services/auth_provider.dart';
import 'package:diary_fit/services/data_provider.dart';
import 'package:diary_fit/utils/navigation_helper.dart';
import 'package:diary_fit/values/app_routes.dart';
import 'package:diary_fit/values/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Logout UI
class LogoutScreen extends StatelessWidget {
  const LogoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.blue,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
              maxHeight: AppSizes.maxWidthWebConstraint,
              maxWidth: AppSizes.maxWidthWebConstraint),
          child: Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  // TODO: colocar string no AppStrings
                  'Fazer logout',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 50),
                const Text(
                  // TODO: colocar string no AppStrings
                  'Deseja mesmo sair do app?',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => NavigationHelper.pop(),
                      // TODO: colocar string no AppStrings
                      child: Text('Cancelar'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Clear the user data
                        context.read<AuthProvider>().logout();
                        context.read<DataProvider>().cleanData();
                        NavigationHelper.pushReplacementNamed(AppRoutes.login);
                      },
                      // TODO: colocar string no AppStrings
                      child: Text('Logout'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
