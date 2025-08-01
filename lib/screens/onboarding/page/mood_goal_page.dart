import 'package:flutter/material.dart';

import '../../../constant/app_colors.dart';
import '../../../widget/build_button.dart';

class MoodGoalPage extends StatefulWidget {
  final VoidCallback? onNext;

  const MoodGoalPage({super.key, this.onNext});

  @override
  State<MoodGoalPage> createState() => _MoodGoalPageState();
}

class _MoodGoalPageState extends State<MoodGoalPage> {
  bool isLoading = true;

  get dietOptions => null;

  void handleNext() {
    // final selected = dietOptions.any((item) => item.isSelected);
    // if (!selected) {
    //   showCustomSnackBar(
    //     context,
    //     message: "Please select at  tour mood.",
    //     icon: Icons.error_outline,
    //     backgroundColor: AppColors.primary1000,
    //   );
    //   return;
    // }

    // Callback to parent
    widget.onNext?.call();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child:
          // isLoading
          //     ? const Center(child: CircularProgressIndicator())
          //     :
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                "How Are You Feeling Today ?",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.secondary1000,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Select allergens to customize your meals.",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.secondary400,
                ),
              ),
              const SizedBox(height: 24),

              Spacer(),

              const SizedBox(height: 16),

              buildButton(
                text: "Next",
                onPressed: handleNext,
                backgroundColor: AppColors.primary1000,
                textColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
