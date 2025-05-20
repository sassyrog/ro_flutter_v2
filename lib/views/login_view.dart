import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pegaplay/gen/assets.gen.dart';
import 'package:pegaplay/gen/colors.gen.dart';
import 'package:pegaplay/gen/fonts.gen.dart';
import 'package:pegaplay/providers/vallidators.dart';
import 'package:pegaplay/widgets/connect_with.dart';
import 'package:pegaplay/widgets/drawer_widget.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Assets.images.logoSvg.svg(width: 40.r, height: 40.r),
        centerTitle: true,
        leading: Builder(
          builder:
              (context) => IconButton(
                icon: Assets.icons.menu.svg(width: 30.w, height: 30.h),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
        ),
      ),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(26),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 40.h),
              Text(
                'Login',
                style: TextStyle(
                  fontFamily: Fonts.aBeeZee,
                  fontSize: 15.w,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: 20.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.r),
                child: Column(
                  children: [
                    FormInputWidget(
                      labelText: 'Email',
                      hintText: 'Enter your email',
                      validator: Validator.apply(context, [
                        RequiredValidation<String>(),
                        EmailValidation(),
                      ]),
                    ),
                    SizedBox(height: 20.h),
                    FormInputWidget(
                      inputType: 'password',
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      validator: Validator.apply(context, [
                        PasswordValidation(),
                      ]),
                    ),
                    SizedBox(height: 30.h),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: EdgeInsets.symmetric(
                          vertical: 8.r,
                          horizontal: 30.r,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        _formKey.currentState!.validate();
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Divider(
                      color: AppColors.secondary,
                      height: 40.0,
                      indent: 30.0,
                      endIndent: 30.0,
                      thickness: 1.0,
                    ),
                    SizedBox(height: 16.h),

                    Divider(
                      color: AppColors.secondary,
                      height: 40.0,
                      indent: 30.0,
                      endIndent: 30.0,
                      thickness: 1.0,
                    ),
                    SizedBox(height: 16.h),
                    ConnectWith(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
