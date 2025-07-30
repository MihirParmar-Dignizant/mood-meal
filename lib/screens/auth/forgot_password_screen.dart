import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mood_meal/constant/app_colors.dart';
import 'package:mood_meal/widget/app_bar.dart';

import '../../router/routes.dart';
import '../../widget/build_button.dart';
import '../../widget/text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary100,
      appBar: const CustomTopAppBar(isImage: true, label: ""),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 30),
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
                            "Forgot Password ?",
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.secondary1000,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Enter your email account to reset password",
                            textAlign: TextAlign.center,
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
                      borderColor: Colors.grey.shade300,
                      textColor: Colors.black,
                    ),
                    const SizedBox(height: 24),
                    buildButton(
                      text: "Reset Password",
                      backgroundColor: AppColors.primary1000,
                      textColor: Colors.white,
                      onPressed: () {
                        bool isValid = formKey.currentState!.validate();
                        if (isValid) {
                          Navigator.pushNamed(
                            context,
                            Routes.checkMail,
                            arguments: emailController.text,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
