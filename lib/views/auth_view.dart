import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pegaplay/gen/assets.gen.dart';
import 'package:pegaplay/gen/colors.gen.dart';
import 'package:pegaplay/gen/fonts.gen.dart';
import 'package:pegaplay/widgets/brightness_icon_widget.dart';

class AuthView extends StatelessWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    bool isPotrait = ScreenUtil().orientation == Orientation.portrait;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final bool isLargeScreen = ScreenUtil().screenWidth > 600;

    if (isLargeScreen) {
      isPotrait = false;
    }

    return Center(
      child: Scaffold(
        appBar: AppBar(
          actions: [BrightnessIconWidget()],
          actionsPadding: EdgeInsets.only(right: 10.0),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: isPotrait ? 200.0.h : 100.0.h,
                    child: FractionallySizedBox(
                      heightFactor: isPotrait ? 0.8 : 1,
                      child: Assets.images.fullLogoSvg.svg(),
                    ),
                  ),
                  SizedBox(height: isPotrait ? 20.0.h : 40.h),
                  Builder(
                    builder: (context) {
                      if (!isPotrait) {
                        return const SizedBox.shrink();
                      }
                      return Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary,
                              blurRadius: 3.0,
                              spreadRadius: 1.0,
                            ),
                          ],
                        ),
                        child: Divider(
                          color: AppColors.primary,
                          thickness: 0.5,
                          height: 3.0,
                        ),
                      );
                    },
                  ),
                  SizedBox(height: isPotrait ? 30.0.h : 0),
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: isPotrait ? double.infinity : 500.0,
                    ),
                    child: Padding(
                      padding:
                          isPotrait
                              ? EdgeInsets.all(20.0.r)
                              : EdgeInsets.only(top: 20.0.r),
                      child: Column(
                        spacing: 20.0,
                        children: [
                          _buildAuthButton(
                            context: context,
                            text: "Login",
                            onPressed:
                                () => {
                                  Navigator.of(
                                    context,
                                  ).pushNamed("/auth/login"),
                                },
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 40.w, right: 40.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              spacing: 5.0,
                              children: [
                                Expanded(child: Divider(thickness: 1.0)),
                                const Text("Or"),
                                Expanded(child: Divider(thickness: 1.0)),
                              ],
                            ),
                          ),

                          _buildAuthButton(
                            context: context,
                            text: "Register",
                            onPressed: () => {},
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildAuthButton({
    required context,
    required text,
    void Function()? onPressed,
  }) {
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: double.infinity),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10.0),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontFamily: Fonts.aBeeZee,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // _buttonStyle(bool isDarkMode) {
  //   return ElevatedButton.styleFrom(
  //     backgroundColor: Colors.white,
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
  //     padding: const EdgeInsets.symmetric(vertical: 10.0),
  //   );
  // }
}
