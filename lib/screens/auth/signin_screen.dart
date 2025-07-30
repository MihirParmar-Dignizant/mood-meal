import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mood_meal/constant/app_colors.dart';
import 'package:mood_meal/widget/app_bar.dart';

import '../../router/routes.dart';
import '../../services/authentication.dart';
import '../../widget/build_button.dart';
import '../../widget/or_divider.dart';
import '../../widget/text_field.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final AuthService authService = AuthService();

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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30),

                    // Card with form
                    Form(
                      key: formKey,
                      child: Container(
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
                                children: [
                                  Text(
                                    "Welcome Back !",
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.secondary1000,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Sign in to continue",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.secondary600,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                            CustomTextField(
                              label: 'Email Address',
                              hint: 'Enter your email address',
                              controller: emailController,
                            ),
                            const SizedBox(height: 10),
                            CustomTextField(
                              label: 'Password',
                              hint: 'Enter your password',
                              isPassword: true,
                              controller: passwordController,
                            ),
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap:
                                    () => Navigator.pushNamed(
                                      context,
                                      Routes.forgotPassword,
                                    ),
                                child: Text(
                                  "Forgot Password?",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: AppColors.primary1000,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            buildButton(
                              text: "Sign In",
                              backgroundColor: AppColors.primary1000,
                              textColor: Colors.white,
                              onPressed: () async {
                                Navigator.pushReplacementNamed(
                                  context,
                                  Routes.signUp,
                                );

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
                                // try {
                                //   final error = await authService.login(
                                //     email: emailController.text.trim(),
                                //     password: passwordController.text.trim(),
                                //   );
                                //
                                //   if (!context.mounted) return;
                                //
                                //   if (error == null) {
                                //     showCustomSnackBar(
                                //       context,
                                //       message: "Login Successful!",
                                //       icon: Icons.check_circle_outline,
                                //       backgroundColor: AppColors.green,
                                //     );
                                //
                                //     await Future.delayed(
                                //       const Duration(milliseconds: 800),
                                //     );
                                //
                                //     Navigator.pushReplacementNamed(
                                //       context,
                                //       Routes.mainHome,
                                //     );
                                //   } else {
                                //     showCustomSnackBar(
                                //       context,
                                //       message: error,
                                //       icon: Icons.error_outline,
                                //       backgroundColor: AppColors.red,
                                //     );
                                //   }
                                // } catch (e) {
                                //   if (!context.mounted) return;
                                //
                                //   showCustomSnackBar(
                                //     context,
                                //     message:
                                //         "Unexpected error occurred. Please try again.",
                                //     icon: Icons.error_outline,
                                //     backgroundColor: Colors.red.shade700,
                                //   );
                                // }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                    const OrDivider(text: "Or sign in with"),
                    const SizedBox(height: 16),

                    // ✅ Google Sign-In Button
                    buildButton(
                      text: "Continue With Google",
                      isGoogle: true,
                      backgroundColor: AppColors.primary100,
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                          context,
                          Routes.mainHome,
                        );
                      },
                    ),

                    const Spacer(),
                    const SizedBox(height: 20),

                    // Sign Up Footer
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don’t have an account ? ",
                          style: TextStyle(
                            color: AppColors.secondary400,
                            fontSize: 14,
                          ),
                        ),
                        GestureDetector(
                          onTap:
                              () => Navigator.pushNamed(context, Routes.signUp),
                          child: Text(
                            "Sign Up",
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
          );
        },
      ),
    );
  }
}
