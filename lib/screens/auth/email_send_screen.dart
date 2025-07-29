import 'package:flutter/material.dart';
import 'package:mood_meal/constant/app_colors.dart';
import 'package:mood_meal/constant/app_image.dart';
import 'package:mood_meal/router/routes.dart';
import 'package:mood_meal/widget/app_bar.dart';

class CheckMailScreen extends StatefulWidget {
  const CheckMailScreen({super.key});

  @override
  State<CheckMailScreen> createState() => _CheckMailScreenState();
}

class _CheckMailScreenState extends State<CheckMailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary100,
      appBar: CustomTopAppBar(
        isImage: true,
        label: "",
      ),
      body: Center(
        child: ElevatedButton(onPressed:() => Navigator.pushNamed(context, Routes.resetPassword), child: Text('Go to Mail')),
      ),
    );
  }
}
