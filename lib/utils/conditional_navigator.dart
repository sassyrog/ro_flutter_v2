import 'dart:async';

import 'package:flutter/material.dart';

/// Navigation methods that can be used with the ConditionalNavigator
enum NavigationMethod {
  push,
  pushReplacement,
  pushAndRemoveUntil,
  pushNamedAndRemoveUntil,
}

/// A utility class that handles conditional navigation with minimum display time
/// and timeout protection.
class ConditionalNavigator {
  static Future<void> navigate({
    required BuildContext context,
    required FutureOr<bool> Function() conditionProvider,
    required String successRoute,
    String? fallbackRoute,
    Function(BuildContext)? fallbackHandler,
    Duration minDisplayTime = const Duration(milliseconds: 2000),
    Duration timeout = const Duration(milliseconds: 10000),
    bool defaultConditionValue = false,
    NavigationMethod navigationMethod = NavigationMethod.pushReplacement,
    bool Function(Route<dynamic>)? removeUntilPredicate,
    Object? successRouteArguments,
    Object? fallbackRouteArguments,
  }) async {
    if (!context.mounted) return;

    final start = DateTime.now();

    // Handle both synchronous and asynchronous condition providers
    bool conditionResult;
    try {
      final result = conditionProvider();
      conditionResult = await (result is bool ? Future.value(result) : result)
          .timeout(timeout);
    } catch (_) {
      // If it times out or errors, use the default value
      conditionResult = defaultConditionValue;
    }

    // Enforce minimum display time
    final elapsed = DateTime.now().difference(start);
    if (elapsed < minDisplayTime) {
      await Future.delayed(minDisplayTime - elapsed);
    }

    // Check if widget is still mounted before navigating
    if (!context.mounted) return;

    // Handle successful condition
    if (conditionResult) {
      // Navigate to success route
      _performNavigation(
        context,
        successRoute,
        navigationMethod,
        removeUntilPredicate,
        successRouteArguments,
      );
    } else {
      // Handle fallback case
      if (fallbackRoute != null) {
        // Navigate to fallback route if provided
        _performNavigation(
          context,
          fallbackRoute,
          navigationMethod,
          removeUntilPredicate,
          fallbackRouteArguments,
        );
      } else if (fallbackHandler != null) {
        // Execute fallback handler if provided
        fallbackHandler(context);
      }
      // If neither fallbackRoute nor fallbackHandler provided, stay on current route
    }
  }

  // Helper method to perform the actual navigation
  static void _performNavigation(
    BuildContext context,
    String route,
    NavigationMethod navigationMethod,
    bool Function(Route<dynamic>)? removeUntilPredicate,
    Object? arguments,
  ) {
    // Use the specified predicate or default to removing all routes
    final predicate = removeUntilPredicate ?? (route) => false;

    switch (navigationMethod) {
      case NavigationMethod.push:
        Navigator.of(context).pushNamed(route, arguments: arguments);
        break;
      case NavigationMethod.pushReplacement:
        Navigator.of(context).pushReplacementNamed(route, arguments: arguments);
        break;
      case NavigationMethod.pushAndRemoveUntil:
      case NavigationMethod.pushNamedAndRemoveUntil:
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil(route, predicate, arguments: arguments);
        break;
    }
  }
}
