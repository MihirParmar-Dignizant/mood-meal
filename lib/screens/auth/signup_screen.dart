import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mood_meal/constant/app_colors.dart';
import 'package:mood_meal/router/routes.dart';
import 'package:mood_meal/widget/app_bar.dart';

import '../../widget/build_button.dart';
import '../../widget/or_divider.dart';
import '../../widget/text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // final AuthService authService = AuthService();

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
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 30),

                      // Card
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.secondary600,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),

                            // Name Field
                            CustomTextField(
                              label: 'Name',
                              hint: 'Enter your Name',
                              controller: nameController,
                            ),

                            const SizedBox(height: 10),

                            // Email Field
                            CustomTextField(
                              label: 'Email Address',
                              hint: 'Enter your email address',
                              controller: emailController,
                            ),

                            const SizedBox(height: 10),

                            // Password Field
                            CustomTextField(
                              label: 'Password',
                              hint: 'Enter your password',
                              isPassword: true,
                              controller: passwordController,
                            ),

                            const SizedBox(height: 24),

                            // Sign Up Button
                            buildButton(
                              text: "Sign Up",
                              backgroundColor: AppColors.primary1000,
                              textColor: Colors.white,
                              onPressed: () async {
                                Navigator.pushNamed(
                                  context,
                                  Routes.forgotPassword,
                                  // (route) => false,
                                );

                                //
                                // if (!formKey.currentState!.validate()) {
                                //   showCustomSnackBar(
                                //     context,
                                //     message:
                                //         "Please fill all fields correctly.",
                                //     icon: Icons.warning_amber_outlined,
                                //     backgroundColor: AppColors.red,
                                //   );
                                //   return;
                                // }
                                //
                                // formKey.currentState!.save();
                                //
                                // final error = await authService.signUp(
                                //   fullName: nameController.text.trim(),
                                //   email: emailController.text.trim(),
                                //   password: passwordController.text.trim(),
                                // );
                                //
                                // if (!context.mounted) return;
                                //
                                // if (error == null) {
                                //   showCustomSnackBar(
                                //     context,
                                //     message: "Login Successful!",
                                //     icon: Icons.check_circle_outline,
                                //     backgroundColor: AppColors.green,
                                //   );
                                //   Navigator.pushNamedAndRemoveUntil(
                                //     context,
                                //     Routes.mainHome,
                                //         (route) => false,
                                //   );
                                // } else {
                                //   showCustomSnackBar(
                                //     context,
                                //     message: error,
                                //     icon: Icons.error_outline,
                                //     backgroundColor: AppColors.red,
                                //   );
                                // }
                              },
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
                          // Google Sign-In
                        },
                      ),

                      const Spacer(), // pushes footer to bottom

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
                                decorationStyle: TextDecorationStyle.solid,
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
