import 'package:flutter/material.dart';
import 'package:mood_meal/constant/app_colors.dart';
import 'package:mood_meal/constant/app_image.dart';
import 'package:mood_meal/router/routes.dart';
import 'package:mood_meal/widget/app_bar.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary100,
      appBar: CustomTopAppBar(
        isImage: true,
        label: "",
      ),
      body: Center(
        child: ElevatedButton(onPressed:() => Navigator.pushNamed(context, Routes.signIn), child: Text('Reset')),
      ),
    );
  }
}
