import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mood_meal/constant/app_colors.dart';
import 'package:mood_meal/widget/app_bar.dart';

import '../../router/routes.dart';
import '../../widget/build_button.dart';
import '../../widget/text_field.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  var formKey = GlobalKey<FormState>();

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

                    // Card
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
                                    "Reset Password !",
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.secondary1000,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Enter your new password",
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
                              label: 'New Password',
                              hint: 'Enter your new password',
                              isPassword: true,
                              controller: passwordController,
                              borderColor: Colors.grey.shade300,
                              textColor: Colors.black,
                            ),
                            const SizedBox(height: 10),
                            CustomTextField(
                              label: 'Confirm New Password',
                              hint: 'Enter your confirm new password',
                              isPassword: true,
                              controller: confirmPasswordController,
                              borderColor: Colors.grey.shade300,
                              textColor: Colors.black,
                            ),
                            const SizedBox(height: 24),

                            buildButton(
                              text: "Save",
                              backgroundColor: AppColors.primary1000,
                              textColor: Colors.white,
                              onPressed: () {
                                Navigator.pushNamed(context, Routes.success);
                                bool isValid = formKey.currentState!.validate();
                                if (!isValid) {
                                  formKey.currentState!.validate();
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
            ),
          );
        },
      ),
    );
  }
}
