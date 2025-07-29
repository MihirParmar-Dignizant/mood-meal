import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mood_meal/constant/app_colors.dart';
import 'package:mood_meal/constant/app_image.dart';

class CustomTopAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isImage;
  final bool showBackButton;
  final String? label;
  final VoidCallback? onBack;

  const CustomTopAppBar({
    super.key,
    required this.isImage,
    this.label,
    this.showBackButton = false,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primary100,
      elevation: 0,
      centerTitle: isImage, // Center only if it's the logo
      title: isImage
          ? Image.asset(
        Assets.moodmeal,
        height: 32.h,
        width: 145.w,
        fit: BoxFit.contain,
      )
          : Text(
        label ?? '',
        style: TextStyle(
          fontSize: 18.sp,
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56.h);

}