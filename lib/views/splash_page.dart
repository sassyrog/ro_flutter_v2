import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pegaplay/data/constants.dart';
import 'package:pegaplay/data/notifiers.dart';
import 'package:pegaplay/gen/assets.gen.dart';
import 'package:pegaplay/gen/colors.gen.dart';
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
    await Future.delayed(const Duration(milliseconds: 1450));

    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isLandscape = constraints.maxWidth > constraints.maxHeight;
            Widget logoContent = Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildLogoElements(),
            );

            if (isLandscape) {
              logoContent = Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: _buildLogoElements(),
                ),
              );
            }

            return logoContent;
          },
        ),
      ),
    );
  }

  List<Widget> _buildLogoElements() {
    return [
      ColorFiltered(
        colorFilter: ColorFilter.mode(AppColors.primary, BlendMode.srcATop),
        child: Assets.lotties.logoSpin.lottie(
          width: 120.w,
          height: 120.h,
          fit: BoxFit.cover,
        ),
      ),
      SizedBox(width: 10.w, height: 10.h),
      Padding(
        padding: EdgeInsets.all(8.0.r),
        child: Assets.images.logoTextSvg.svg(
          width: 120.w,
          fit: BoxFit.fitWidth,
        ),
      ),
    ];
  }
}
