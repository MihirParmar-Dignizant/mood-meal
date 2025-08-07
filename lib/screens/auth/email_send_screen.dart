import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mood_meal/constant/app_colors.dart';
import 'package:mood_meal/constant/app_image.dart';
import 'package:mood_meal/router/routes.dart';
import 'package:mood_meal/widget/app_bar.dart';

import '../../widget/build_button.dart';

class CheckMailScreen extends StatefulWidget {
  const CheckMailScreen({super.key});

  @override
  State<CheckMailScreen> createState() => _CheckMailScreenState();
}

class _CheckMailScreenState extends State<CheckMailScreen> {
  String? email;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    email = ModalRoute.of(context)!.settings.arguments as String?;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary100,
      resizeToAvoidBottomInset: true,
      appBar: const CustomTopAppBar(isImage: true, label: ""),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 48,
                      child: SvgPicture.asset(
                        Assets.emailSvg,
                        height: 36,
                        width: 36,
                        colorFilter: const ColorFilter.mode(
                          AppColors.primary1000,
                          BlendMode.srcIn,
                        ),
                        placeholderBuilder:
                            (context) => const CircularProgressIndicator(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Please check your inbox!",
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.secondary1000,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "We've sent a code to $email",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: AppColors.secondary600,
                      ),
                    ),
                    const SizedBox(height: 24),
                    buildButton(
                      text: "Go To Mail",
                      backgroundColor: AppColors.primary1000,
                      textColor: Colors.white,
                      onPressed: () {
                        Navigator.pushNamed(context, Routes.resetPassword);
                      },
                    ),
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
