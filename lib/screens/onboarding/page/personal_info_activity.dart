import 'package:flutter/material.dart';

import '../../../constant/app_colors.dart';
import '../../../widget/build_button.dart';
import '../../../widget/snackBar.dart';

class PersonalInfoActivityPage extends StatefulWidget {
  final VoidCallback? onNext;

  const PersonalInfoActivityPage({super.key, this.onNext});

  @override
  State<PersonalInfoActivityPage> createState() =>
      _PersonalInfoActivityPageState();
}

class _PersonalInfoActivityPageState extends State<PersonalInfoActivityPage> {
  bool isLoading = true;

  get dietOptions => null;

  int? selectedActivityIndex;

  final List<Map<String, String>> activityOptions = [
    {
      'title': 'Sedentary',
      'description': 'Minimal movement, mostly sitting, low physical activity.',
    },
    {
      'title': 'Lightly Active',
      'description': '1-3 times weekly, moderate energy expenditure.',
    },
    {
      'title': 'Moderately Active',
      'description': 'Moderate exercise 3-5 days, balanced fitness routine.',
    },
    {
      'title': 'Very Active',
      'description':
          'Intense exercise daily, high physical demand and endurance.',
    },
  ];

  void handleNext() {
    if (selectedActivityIndex == null) {
      showCustomSnackBar(
        context,
        message: "Please select your activity level.",
        icon: Icons.error_outline,
        backgroundColor: AppColors.primary1000,
      );
      return;
    }

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
                "Choose Your Activity Level",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.secondary1000,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Select intensity for better recommendations!",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.secondary400,
                ),
              ),
              const SizedBox(height: 24),

              Expanded(
                child: ListView.builder(
                  itemCount: activityOptions.length,
                  itemBuilder: (context, index) {
                    final option = activityOptions[index];
                    final isSelected = selectedActivityIndex == index;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedActivityIndex = index;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color:
                                isSelected
                                    ? AppColors.primary1000
                                    : AppColors.secondary100,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Radio<int>(
                              value: index,
                              groupValue: selectedActivityIndex,
                              onChanged: (value) {
                                setState(() {
                                  selectedActivityIndex = value;
                                });
                              },
                              activeColor: AppColors.primary1000,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    option['title']!,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.secondary1000,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    option['description']!,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.secondary500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

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
