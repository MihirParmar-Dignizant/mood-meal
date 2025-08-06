import 'package:flutter/material.dart';

import '../../../constant/app_colors.dart';
import '../../../services/api/api_services.dart';
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

  bool isLoading = false;

  void handleNext() async {
    final isValid = formKey.currentState?.validate() ?? false;

    if (!isValid ||
        genderController.text.trim().isEmpty ||
        ageController.text.trim().isEmpty ||
        weightController.text.trim().isEmpty ||
        heightController.text.trim().isEmpty) {
      showCustomSnackBar(
        context,
        message: "Please complete all required fields correctly.",
        icon: Icons.error_outline,
        backgroundColor: AppColors.primary1000,
      );
      return;
    }

    final trimmedAge = ageController.text.trim();
    final age = int.tryParse(trimmedAge);

    if (age == null) {
      showCustomSnackBar(
        context,
        message: "Please enter a valid age.",
        icon: Icons.error_outline,
        backgroundColor: AppColors.primary1000,
      );
      return;
    }

    String gender = genderController.text.trim();
    String weight = weightController.text.trim();
    String height = heightController.text.trim();

    // Convert height from ft/in to cm if needed
    if (height.contains("ft")) {
      try {
        final parts = height.split(" ");
        final feet = int.parse(parts[0]);
        final inches = int.parse(parts[2]);
        final totalCm = (feet * 30.48 + inches * 2.54).round();
        height = "$totalCm cm";
      } catch (_) {
        showCustomSnackBar(
          context,
          message: "Invalid height format.",
          icon: Icons.error_outline,
          backgroundColor: AppColors.primary1000,
        );
        return;
      }
    }

    setState(() => isLoading = true);

    try {
      final response = await ApiService.updatePersonalInfo(
        gender: gender,
        age: trimmedAge,
        weight: weight,
        height: height,
      );

      debugPrint("Profile updated for user ID: ${response.user.id}");

      widget.onNext?.call();
    } catch (e) {
      showCustomSnackBar(
        context,
        message: e.toString(),
        icon: Icons.error_outline,
        backgroundColor: AppColors.primary1000,
      );
    } finally {
      setState(() => isLoading = false);
    }
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

              buildButton(
                text: isLoading ? "Saving..." : "Next",
                onPressed: isLoading ? null : handleNext,
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
