import 'package:flutter/material.dart';

// Navigation helper
// Based on MaterialApp navigation key
// With this helper, context is not necessary
class NavigationHelper {
  const NavigationHelper._(); // Private constructor to prevent instantiation

  static final _key = GlobalKey<NavigatorState>();

  static GlobalKey<NavigatorState> get key => _key;

  // pushes the route in the route stack
  static Future<T?>? pushNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) {
    return _key.currentState?.pushNamed<T?>(
      routeName,
      arguments: arguments,
    );
  }

  // replaces the route
  static Future<T?>? pushReplacementNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) {
    return _key.currentState?.pushReplacementNamed(
      routeName,
      arguments: arguments,
    );
  }

  // pops the route stack
  static void pop<T extends Object?>([T? result]) {
    return _key.currentState?.pop(result);
  }
}