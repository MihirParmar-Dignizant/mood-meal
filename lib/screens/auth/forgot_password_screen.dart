import 'package:flutter/material.dart';
import 'package:mood_meal/constant/app_colors.dart';
import 'package:mood_meal/constant/app_image.dart';
import 'package:mood_meal/widget/app_bar.dart';

import '../../router/routes.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary100,
      appBar: CustomTopAppBar(
        isImage: true,
        showBackButton: true,
        label: "",
      ),
      body: Center(
        child: ElevatedButton(onPressed:() => Navigator.pushNamed(context, Routes.checkMail), child: Text('Forgot')),
      ),
    );
  }
}
