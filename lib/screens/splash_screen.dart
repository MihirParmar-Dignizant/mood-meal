import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mood_meal/constant/app_colors.dart';

import '../constant/app_image.dart';
import '../router/routes.dart';
import '../services/local_db/shared_pref_data.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateAfterDelay();
  }

  Future<void> _navigateAfterDelay() async {
    await Future.delayed(const Duration(seconds: 3));
    bool isLoggedIn = await LocalUserPrefs.isUserLoggedIn();

    if (isLoggedIn) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.mainHome,
        (route) => false, // removes all previous routes
      );
    } else {
      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.signIn,
        (route) => false, // removes all previous routes
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.primary100,
      body: Padding(
        padding: const EdgeInsets.only(top: 130),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(Assets.moodmeal, height: 39.h, width: 175.w),
            ),
            SizedBox(height: 5.h),
            Text(
              'Your Mood. Your Meal. Simplified',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.secondary500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
