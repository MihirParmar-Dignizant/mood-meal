import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mood_meal/router/app_router.dart';
import 'package:mood_meal/router/routes.dart';
import 'package:mood_meal/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) {
        return SafeArea(
          top: false,
          bottom: false,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Mood Meal',
            initialRoute: Routes.splash,
            routes: AppRouter.appRoutes,
          ),
        );
      },
    );
  }
}
