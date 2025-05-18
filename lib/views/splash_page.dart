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
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    _initTheme();
    await Future.delayed(const Duration(seconds: 10));
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _initTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool isDarkMode = prefs.getBool(KConstants.themeModeKey) ?? false;
    isDarkModeNotifier.value = isDarkMode;
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading ? _buildSpashScreen() : _buildMainApp();
  }

  Widget _buildSpashScreen() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                AppColors.primary,
                BlendMode.srcATop,
              ),
              child: Assets.lotties.logoSpin.lottie(
                width: 200,
                height: 200,
                fit: BoxFit.cover,
                repeat: true,
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Assets.images.logoText.svg(
                width: 200,
                fit: BoxFit.fitWidth,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainApp() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacementNamed(context, '/login');
    });

    return Container();
  }
}
