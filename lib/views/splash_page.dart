import 'package:flutter/material.dart';
import 'package:ro_flutter/data/constants.dart';
import 'package:ro_flutter/data/notifiers.dart';
import 'package:ro_flutter/gen/assets.gen.dart';
import 'package:ro_flutter/gen/colors.gen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateAfterDelay();
  }

  Future<void> _navigateAfterDelay() async {
    // Minimum splash duration (adjust as needed)
    await Future.delayed(const Duration(milliseconds: 1500));

    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Pre-cached Lottie will animate smoothly
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                AppColors.primary,
                BlendMode.srcATop,
              ),
              child: Assets.lotties.logoSpin.lottie(
                width: 175,
                height: 175,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            // Pre-cached SVG
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Assets.images.logoText.svg(
                width: 175,
                fit: BoxFit.fitWidth,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
