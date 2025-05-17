import 'package:flutter/material.dart';
import 'package:ro_flutter/data/notifiers.dart';
import 'package:ro_flutter/views/home_page.dart';
import 'package:ro_flutter/views/login_view.dart';
import 'package:ro_flutter/views/splash_page.dart';

void main() {
  runApp(const MyApp());
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
          title: 'Ro Flutter',
          debugShowCheckedModeBanner: false,
          theme:
              isDarkModeValue
                  ? _buildDarkTheme(context)
                  : _buildLightTheme(context),
          darkTheme: _buildDarkTheme(context),
          themeMode: isDarkModeValue ? ThemeMode.dark : ThemeMode.light,
          initialRoute: '/', // Initial route is splash
          routes: {
            '/': (context) => const SplashScreen(),
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
    const primaryColor = Color(0xFF488286);
    const secondaryColor = Color(0xFFb7d5d4);
    const tertiaryColor = Color(0xFF071E1E);
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
        onSurface: tertiaryColor,
        onError: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceColor,
        foregroundColor: Colors.black,
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
    const primaryColor = Color(0xFF488286);
    const secondaryColor = Color(0xFFb7d5d4);
    const surfaceColor = Color(0xFF071E1E);
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
