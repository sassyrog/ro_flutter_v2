import 'package:flutter/material.dart';
import 'package:ro_flutter/gen/assets.gen.dart';
import 'package:ro_flutter/gen/colors.gen.dart';
import 'package:ro_flutter/gen/fonts.gen.dart';
import 'package:ro_flutter/widgets/drawer_widget.dart';
import 'package:ro_flutter/widgets/form/form_input_widget.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Assets.images.logo.svg(width: 60, height: 60),
        centerTitle: true,
      ),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(26),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 100),
            const Text(
              'Login',
              style: TextStyle(
                fontFamily: Fonts.aBeeZee,
                fontSize: 26.0,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  FormInputWidget(
                    labelText: 'Email',
                    hintText: 'Enter your email',
                  ),
                  const SizedBox(height: 20),
                  FormInputWidget(
                    inputType: 'password',
                    labelText: 'Password',
                    hintText: 'Enter your password',
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 60,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      // Handle login logic here
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Divider(
                    color: AppColors.secondary,
                    height: 40.0,
                    thickness: 1.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
