import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mood_meal/constant/app_colors.dart';
import 'package:mood_meal/constant/app_image.dart';

class CustomTopAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isImage;
  final String? label;
  final bool showBackButton;
  final VoidCallback? onBack;
  final Color? backgroundColor;

  const CustomTopAppBar({
    super.key,
    required this.isImage,
    this.label,
    this.showBackButton = false,
    this.onBack,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.primary100,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Stack(
        children: [
          // Centered title (Image or Text)
          Center(
            child:
                isImage
                    ? Image.asset(
                      Assets.moodmeal,
                      height: 32.h,
                      width: 145.w,
                      fit: BoxFit.contain,
                    )
                    : Text(
                      label ?? '',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
          ),

          // Back Arrow (left)
          if (showBackButton)
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: onBack ?? () => Navigator.pop(context),
                behavior: HitTestBehavior.translucent,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.black,
                    size: 22.sp,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(70.h);
}
