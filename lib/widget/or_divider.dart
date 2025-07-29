import 'package:flutter/material.dart';
import '../constant/app_colors.dart';

class OrDivider extends StatelessWidget {
  final String? text; // nullable and no default

  const OrDivider({super.key, this.text});

  @override
  Widget build(BuildContext context) {
    final hasText = text != null && text!.trim().isNotEmpty;

    return Row(
      children: [
        Expanded(
          child: Container(
            height: 2,
            margin: EdgeInsets.only(right: hasText ? 10 : 0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.secondary600.withAlpha(0),
                  AppColors.secondary600.withAlpha(150),
                ],
                stops: const [0.25, 1.0],
              ),
            ),
          ),
        ),

        if (hasText)
          Text(
            text!,
            style: TextStyle(
              color: AppColors.secondary600,
              fontWeight: FontWeight.w600,
            ),
          ),

        Expanded(
          child: Container(
            height: 2,
            margin: EdgeInsets.only(left: hasText ? 10 : 0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.secondary600.withAlpha(150),
                  AppColors.secondary600.withAlpha(0),
                ],
                stops: const [0.0, 0.75],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
