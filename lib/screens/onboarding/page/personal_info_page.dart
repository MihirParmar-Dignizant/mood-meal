import 'package:flutter/material.dart';

import '../../../constant/app_colors.dart';
import '../../../widget/build_button.dart';
import '../../../widget/picker_bottomSheet.dart';
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
  final weightController = TextEditingController();
  final heightController = TextEditingController();

  void handleNext() {
    final isValid = formKey.currentState?.validate() ?? false;

    if (!isValid ||
        genderController.text.isEmpty ||
        ageController.text.isEmpty ||
        weightController.text.isEmpty ||
        heightController.text.isEmpty) {
      showCustomSnackBar(
        context,
        message: "Please complete all required fields correctly.",
        icon: Icons.error_outline,
        backgroundColor: AppColors.primary1000,
      );
      return;
    }

    widget.onNext?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
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
                "Share basic details for smarter suggestions",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.secondary400,
                ),
              ),
              const SizedBox(height: 20),

              Expanded(
                child: SingleChildScrollView(
                  // padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Form(
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
                        const SizedBox(height: 16),

                        CustomTextField(
                          label: 'Age',
                          isNumber: true,
                          hint: 'Enter your Age',
                          controller: ageController,
                        ),
                        const SizedBox(height: 16),

                        CustomTextField(
                          label: "Weight",
                          hint: "Select your weight",
                          controller: weightController,
                          onTapOverride: () {
                            final items = List.generate(
                              180,
                              (i) => (30 + i).toString(),
                            );
                            showCustomPickerBottomSheet(
                              context: context,
                              title: "Select Your Weight",
                              items: items,
                              unit: "kg",
                              initialIndex: items
                                  .indexOf(
                                    weightController.text
                                        .replaceAll("kg", "")
                                        .trim(),
                                  )
                                  .clamp(0, items.length - 1),
                              onItemSelected: (selected) {
                                weightController.text = "$selected kg";
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 16),

                        CustomTextField(
                          label: "Height",
                          hint: "Select your height",
                          controller: heightController,
                          onTapOverride: () {
                            final cmItems = List.generate(
                              120,
                              (i) => (100 + i).toString(),
                            );
                            showCustomPickerBottomSheet(
                              context: context,
                              title: "Select Your Height",
                              items: cmItems,
                              unit: "cm",
                              showUnitToggle: true,
                              onItemSelectedCm: (selected) {
                                heightController.text = "$selected cm";
                              },
                              onItemSelectedFtIn: (ftInList) {
                                heightController.text =
                                    "${ftInList[0]} ft ${ftInList[1]} in";
                              },
                              onItemSelected: (_) {},
                            );
                          },
                        ),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ),

              // Bottom button
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

  @override
  void dispose() {
    genderController.dispose();
    ageController.dispose();
    weightController.dispose();
    heightController.dispose();
    super.dispose();
  }
}
