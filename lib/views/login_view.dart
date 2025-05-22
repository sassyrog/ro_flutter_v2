import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pegaplay/gen/assets.gen.dart';
import 'package:pegaplay/gen/colors.gen.dart';
import 'package:pegaplay/gen/fonts.gen.dart';
import 'package:pegaplay/providers/vallidators.dart';
import 'package:pegaplay/widgets/connect_with.dart';
import 'package:pegaplay/widgets/form/form_input_widget.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    bool isPotrait = ScreenUtil().orientation == Orientation.portrait;

    return Scaffold(
      appBar: AppBar(
        title: Assets.images.logoTextSvg.svg(height: 40),
        // actions: [BrightnessIconWidget()],
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Center(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: isPotrait ? double.infinity : 500.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 40.h,
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontFamily: Fonts.aBeeZee,
                          fontSize: 18.0.r,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        spacing: 20.0,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          FormInputWidget(
                            labelText: 'Email',
                            hintText: 'Enter your email',
                            validator: Validator.apply(context, [
                              RequiredValidation<String>(),
                              EmailValidation(),
                            ]),
                          ),
                          FormInputWidget(
                            inputType: 'password',
                            labelText: 'Password',
                            hintText: 'Enter your password',
                            validator: Validator.apply(context, [
                              PasswordValidation(),
                            ]),
                          ),
                          SizedBox(height: 6.h),
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: double.infinity,
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10.0,
                                ),
                              ),
                              onPressed: () {},
                              child: Text(
                                "Login",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: Fonts.aBeeZee,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 40.h),
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
                    SizedBox(height: 36.h),
                    ConnectWith(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
