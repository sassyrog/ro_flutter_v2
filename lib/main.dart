import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ro_flutter/data/constants.dart';
import 'package:ro_flutter/data/notifiers.dart';
import 'package:ro_flutter/gen/assets.gen.dart';
import 'package:ro_flutter/gen/colors.gen.dart';
import 'package:ro_flutter/views/home_page.dart';
import 'package:ro_flutter/views/login_view.dart';
import 'package:ro_flutter/views/splash_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.black, // Match splash background
    ),
  );

  await Future.wait([
    initializeTheme(),
    AssetPrecacher.precacheAll(),
    // Add other initializations here if needed
  ]);

  runApp(const MyApp());
}

Future<void> initializeTheme() async {
  final prefs = await SharedPreferences.getInstance();

  final hasThemePreference = prefs.containsKey(KConstants.themeModeKey);

  if (!hasThemePreference) {
    final brightness = PlatformDispatcher.instance.platformBrightness;
    final isSystemDarkMode = brightness == Brightness.dark;

    await prefs.setBool(KConstants.themeModeKey, isSystemDarkMode);

    isDarkModeNotifier.value = isSystemDarkMode;
  } else {
    final isDark = prefs.getBool(KConstants.themeModeKey) ?? false;
    isDarkModeNotifier.value = isDark;
  }
}

class AssetPrecacher {
  static Future<void> precacheAll() async {
    try {
      await Future.wait([_precacheImages(), _precacheLotties()]);
    } catch (e) {
      debugPrint('Precaching error: $e');
    }
  }

  static Future<void> _precacheImages() async {
    final images = [Assets.images.logoText];

    await Future.wait(
      images.map((image) async {
        final loader = SvgAssetLoader(image.path);
        await (svg.cache.putIfAbsent(
          loader.cacheKey(null),
          () => loader.loadBytes(null),
        ));
      }),
    );
  }

  static Future<void> _precacheLotties() async {
    final lotties = [Assets.lotties.logoSpin];
    await Future.wait(lotties.map((lottie) => rootBundle.load(lottie.path)));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDarkModeValue, child) {
        return MaterialApp(
          title: KConstants.appName,
          debugShowCheckedModeBanner: false,
          theme:
              isDarkModeValue
                  ? _buildDarkTheme(context)
                  : _buildLightTheme(context),
          darkTheme: _buildDarkTheme(context),
          themeMode: isDarkModeValue ? ThemeMode.dark : ThemeMode.light,
          home: const SplashScreen(),
          initialRoute: '/', // Initial route is splash
          routes: {
            '/home': (context) => const HomePage(),
            '/login': (context) => const LoginView(),
          },
        );
      },
    );
  }

  // TextTheme _appTextTheme(BuildContext context) {
  //   return const GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme);
  // }

  ThemeData _buildLightTheme(BuildContext context) {
    // Light theme colors
    const primaryColor = AppColors.primary;
    const secondaryColor = AppColors.secondary;
    const tertiaryColor = AppColors.tertiary;
    const surfaceColor = Colors.white;
    const errorColor = Color(0xFFB00020);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: 'Poppins',
      textTheme: Theme.of(context).textTheme.apply(
        fontSizeFactor: 1.1,
        fontSizeDelta: 2.0,
        // bodyColor: tertiaryColor,
      ),

      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: tertiaryColor,
        surface: surfaceColor,
        error: errorColor,
        onPrimary: Colors.white,
        onSecondary: tertiaryColor,
        onSurface: AppColors.primary2,
        onError: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceColor,
        foregroundColor: AppColors.tertiary,
      ),
      drawerTheme: DrawerThemeData(backgroundColor: secondaryColor),
      cardTheme: const CardTheme(
        color: surfaceColor,
        shadowColor: Color(0xFF373e40),
        elevation: 4,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
    );
  }

  ThemeData _buildDarkTheme(BuildContext context) {
    // Dark theme colors
    const primaryColor = AppColors.primary;
    const secondaryColor = AppColors.secondary;
    const surfaceColor = AppColors.primaryDark;
    const errorColor = Color(0xFFB00020);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: 'Poppins',
      textTheme: Theme.of(context).textTheme.apply(
        fontSizeFactor: 1.1,
        fontSizeDelta: 2.0,
        bodyColor: Colors.white,
      ),

      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: surfaceColor,
        error: errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onSurface: Colors.white,
        onError: Colors.black,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceColor,
        foregroundColor: Colors.white,
      ),
      cardTheme: const CardTheme(
        color: surfaceColor,
        shadowColor: Colors.white,
        elevation: 4,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: secondaryColor,
        foregroundColor: Colors.black,
      ),
    );
  }
}
