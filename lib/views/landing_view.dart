import 'package:flutter/material.dart';
import 'package:pegaplay/providers/auth_provider.dart';
import 'package:pegaplay/views/splash_page.dart';
import 'package:pegaplay/utils/conditional_navigator.dart'; // Import our new utility

class LandingView extends StatefulWidget {
  const LandingView({super.key});
  @override
  State<LandingView> createState() => _LandingViewState();
}

class _LandingViewState extends State<LandingView> {
  @override
  void initState() {
    super.initState();
    _goNext();
  }

  Future<void> _goNext() async {
    // Use our reusable conditional navigator
    await ConditionalNavigator.navigate(
      context: context,
      conditionProvider: () => AuthProvider.instance.isAuthenticated,
      successRoute: '/home',
      fallbackRoute: '/auth',
      defaultConditionValue: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: SplashScreen()));
  }
}
