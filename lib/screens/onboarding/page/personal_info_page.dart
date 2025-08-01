import 'package:flutter/material.dart';

import '../../../constant/app_colors.dart';
import '../../../widget/build_button.dart';
import '../../../widget/snackBar.dart';
import '../../../widget/text_field.dart';

class PersonalInfoPage extends StatefulWidget {
  final VoidCallback? onNext;

  const PersonalInfoPage({super.key, this.onNext});

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  final formKey = GlobalKey<FormState>();
  final genderController = TextEditingController();
  final ageController = TextEditingController();

  bool isLoading = true;

  get dietOptions => null;

  void handleNext() {
    final selected = dietOptions.any((item) => item.isSelected);
    if (!selected) {
      showCustomSnackBar(
        context,
        message: "Please select at  tour mood.",
        icon: Icons.error_outline,
        backgroundColor: AppColors.primary1000,
      );
      return;
    }

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
                "Tell Us About Yourself",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.secondary1000,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Share basics details for smarter suggestions",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.secondary400,
                ),
              ),
              const SizedBox(height: 20),

              Form(
                key: formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      label: 'Gender',
                      hint: 'Select your Gender',
                      isDropdown: true,
                      dropdownItems: ['Male', 'Female', 'Other'],
                      controller: genderController,
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      label: 'Age',
                      hint: 'Enter your Age',
                      controller: ageController,
                    ),
                  ],
                ),
              ),
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
