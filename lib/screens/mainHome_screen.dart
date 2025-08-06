import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mood_meal/constant/app_colors.dart';

import '../router/routes.dart';
import '../services/authentication.dart';

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Main Home Screen ",
              style: TextStyle(fontSize: 30.sp, color: AppColors.primary1000),
            ),

            const SizedBox(height: 50),

            ElevatedButton(
              onPressed: () async {
                // await FirebaseAuth.instance.signOut();
                await AuthService.signOut();

                Navigator.pushNamedAndRemoveUntil(
                  context,
                  Routes.signIn,
                  (route) => false, // removes all previous routes
                );
              },
              child: Text('Forgot'),
            ),
          ],
        ),
      ),
    );
  }
}
