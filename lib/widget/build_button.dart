import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constant/app_image.dart';

Widget buildButton({
  required String text,
  VoidCallback? onPressed,
  bool isGoogle = false,
  Color backgroundColor = Colors.white,
  Color textColor = Colors.black,
  double borderRadius = 8,
  EdgeInsetsGeometry padding = const EdgeInsets.symmetric(vertical: 14),
}) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        padding: padding,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Show Google logo if it's a Google button
          if (isGoogle) ...[
            Image.asset(
              Assets.googleLogo, // <- Your image path here
              height: 20,
              width: 20,
            ),
            const SizedBox(width: 10),
          ],
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500
            ),
          ),
        ],
      ),
    ),
  );
}
