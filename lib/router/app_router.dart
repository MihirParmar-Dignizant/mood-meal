import 'package:flutter/material.dart';
import 'package:mood_meal/router/routes.dart';
import 'package:mood_meal/screens/auth/email_send_screen.dart';
import 'package:mood_meal/screens/auth/forgot_password_screen.dart';
import 'package:mood_meal/screens/auth/reset_password_screen.dart';
import 'package:mood_meal/screens/auth/signin_screen.dart';
import 'package:mood_meal/screens/auth/successful_message.dart';
import 'package:mood_meal/screens/mainHome_screen.dart';
import 'package:mood_meal/screens/onboarding/dietary_prefrence.dart';
import 'package:mood_meal/screens/splash_screen.dart';

import '../screens/auth/signup_screen.dart';

class AppRouter {
  static Map<String, WidgetBuilder> appRoutes = {
    Routes.splash: (context) => const SplashScreen(),
    Routes.signIn: (context) => const SignInScreen(),
    Routes.signUp: (context) => const SignUpScreen(),
    Routes.forgotPassword: (context) => const ForgotPasswordScreen(),
    Routes.checkMail: (context) => const CheckMailScreen(),
    Routes.resetPassword: (context) => const ResetPasswordScreen(),
    Routes.mainHome: (context) => const MainHomeScreen(),
    Routes.success: (context) => const SuccessScreen(),
    Routes.dietary: (context) => const DietaryPrefScreen(),
  };
}
