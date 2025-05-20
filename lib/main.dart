import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pegaplay/data/constants.dart';
import 'package:pegaplay/data/notifiers.dart';
import 'package:pegaplay/gen/assets.gen.dart';
import 'package:pegaplay/gen/colors.gen.dart';
import 'package:pegaplay/providers/auth_provider.dart';
import 'package:pegaplay/services/auth/sportify_auth.dart';
import 'package:pegaplay/services/deep_link_handler.dart';
import 'package:pegaplay/views/home_page.dart';
import 'package:pegaplay/views/login_view.dart';
import 'package:pegaplay/views/splash_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  // Initialize Flutter bindings
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: "config.env");

  // Setup authorization provider
  final authProvider = AuthProvider.instance;
  authProvider.initializeServices({
    AuthServiceType.spotify: SpotifyAuthService(),
    // Add other auth services here
  });

  // Perform parallel initialization of important services
  await Future.wait([
    initializeTheme(),
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
    authProvider.initializeAll(),
    // Add other initializations here if needed
  ]);

  // Precache assets in the background
  AssetPrecacher.precacheAll();

  // Run the app with the auth provider
  runApp(
    ChangeNotifierProvider.value(value: authProvider, child: const MyApp()),
  );
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
    final images = [];

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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final DeepLinkHandler _deepLinkHandler = DeepLinkHandler();
  // This widget is the root of your application.

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _deepLinkHandler.initDeepLinks(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Wrap your MaterialApp with ScreenUtilInit
    return ScreenUtilInit(
      designSize: const Size(360, 690), // Use your design dimensions here
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
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
              initialRoute: '/login',
              routes: {
                '/': (context) => const SplashScreen(),
                '/home': (context) => const HomePage(),
                '/login': (context) => const LoginView(),
              },
            );
          },
        );
      },
      child: const LoginView(), // Optional child widget
    );
  }

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
      textTheme: Theme.of(context).textTheme.apply(bodyColor: Colors.black),

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
      textTheme: Theme.of(context).textTheme.apply(bodyColor: Colors.white),

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

  @override
  void dispose() {
    super.dispose();
  }
}
