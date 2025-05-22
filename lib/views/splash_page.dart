import 'package:flutter/material.dart';
import 'package:pegaplay/gen/assets.gen.dart';
import 'package:pegaplay/gen/colors.gen.dart';

/// A simple splash screen that displays the logo animation without
/// any internal navigation or delays. Uses fixed double sizes and
/// manual orientation check with MediaQuery.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Determine orientation based on screen dimensions
    final size = MediaQuery.of(context).size;
    final bool isLandscape = size.width > size.height;

    // Build the animated logo widget
    final logoWidgets = _buildLogoElements();

    return Scaffold(
      body: Center(
        child:
            isLandscape
                ? Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: logoWidgets,
                )
                : Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: logoWidgets,
                ),
      ),
    );
  }

  List<Widget> _buildLogoElements() {
    return [
      ColorFiltered(
        colorFilter: const ColorFilter.mode(
          AppColors.primary,
          BlendMode.srcATop,
        ),
        child: Assets.lotties.logoSpin.lottie(
          width: 120.0,
          height: 120.0,
          repeat: false,
          fit: BoxFit.cover,
        ),
      ),
      const SizedBox(width: 10.0, height: 10.0),
      Padding(
        padding: EdgeInsets.all(8.0),
        child: Assets.images.logoTextSvg.svg(
          width: 120.0,
          fit: BoxFit.fitWidth,
        ),
      ),
    ];
  }
}
