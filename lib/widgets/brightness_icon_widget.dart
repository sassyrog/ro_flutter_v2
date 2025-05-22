import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:pegaplay/data/constants.dart';
import 'package:pegaplay/data/notifiers.dart';
import 'package:pegaplay/gen/colors.gen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BrightnessIconWidget extends StatelessWidget {
  const BrightnessIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    void onDarkModeToggle() async {
      isDarkModeNotifier.value = !isDarkMode;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool(KConstants.themeModeKey, !isDarkMode);
    }

    return IconButton(
      style: IconButton.styleFrom(
        backgroundColor: AppColors.primary.withValues(alpha: 0.1),
      ),
      color: AppColors.primary,
      onPressed: onDarkModeToggle,
      icon: Icon(isDarkMode ? LucideIcons.sun : LucideIcons.moonStar),
    );
  }
}
