import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mood_meal/constant/app_colors.dart';
import 'package:mood_meal/router/routes.dart';
import 'package:mood_meal/widget/app_bar.dart';

import '../../../../widget/build_button.dart';
import '../../../../widget/or_divider.dart';
import '../../../../widget/snackBar.dart';
import '../../../../widget/text_field.dart';
import '../viewModel/signup_viewmodel.dart'; // Add this import

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final SignUpViewModel viewModel = SignUpViewModel();
  bool _isLoading = false;

  void handleSignUp() async {
    setState(() => _isLoading = true);

    final result = await viewModel.submitForm();

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (result == null) {
      showCustomSnackBar(
        context,
        message: "Sign up successful!",
        icon: Icons.check_circle_outline,
        backgroundColor: Colors.green,
      );

      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.mainHome,
        (route) => false,
      );
    } else {
      showCustomSnackBar(
        context,
        message: result,
        icon: Icons.error_outline,
        backgroundColor: Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary100,
      appBar: const CustomTopAppBar(isImage: true, label: ""),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Form(
                  key: viewModel.formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(30),
                              blurRadius: 12,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              "Welcome to mood meal!",
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.secondary1000,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Create account, explore meals for moods.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.secondary600,
                              ),
                            ),
                            const SizedBox(height: 20),

                            CustomTextField(
                              label: 'First Name',
                              hint: 'Enter your first name',
                              controller: viewModel.fNameController,
                            ),
                            const SizedBox(height: 10),
                            CustomTextField(
                              label: 'Last Name',
                              hint: 'Enter your last name',
                              controller: viewModel.lNameController,
                            ),
                            const SizedBox(height: 10),
                            CustomTextField(
                              label: 'User Name',
                              hint: 'Enter unique username',
                              controller: viewModel.userNameController,
                            ),
                            const SizedBox(height: 10),
                            CustomTextField(
                              label: 'Email Address',
                              hint: 'Enter your email',
                              controller: viewModel.emailController,
                            ),
                            const SizedBox(height: 10),
                            CustomTextField(
                              label: 'Password',
                              hint: 'Enter your password',
                              isPassword: true,
                              controller: viewModel.passwordController,
                            ),
                            const SizedBox(height: 24),

                            _isLoading
                                ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                                : buildButton(
                                  text: "Sign Up",
                                  backgroundColor: AppColors.primary1000,
                                  textColor: Colors.white,
                                  onPressed: handleSignUp,
                                ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      const OrDivider(text: "Or signup with"),
                      const SizedBox(height: 16),

                      buildButton(
                        text: "Continue With Google",
                        isGoogle: true,
                        backgroundColor: AppColors.primary100,
                        onPressed: () {
                          // TODO: Google Sign-In
                        },
                      ),

                      const Spacer(),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account?",
                            style: TextStyle(
                              color: AppColors.secondary400,
                              fontSize: 14,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Text(
                              " Sign In",
                              style: TextStyle(
                                color: AppColors.primary1000,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                decoration: TextDecoration.underline,
                                decorationColor: AppColors.primary1000,
                                decorationThickness: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
