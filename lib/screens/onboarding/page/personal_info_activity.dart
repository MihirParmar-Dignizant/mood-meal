import 'package:flutter/material.dart';
import 'package:mood_meal/services/api/api_services.dart';
import 'package:mood_meal/services/model/onboarding/activity_level.dart';

import '../../../constant/app_colors.dart';
import '../../../router/routes.dart';
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
  List<ActivityLevel> activityOptions = [];
  int? selectedActivityIndex;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchActivityOptions();
  }

  Future<void> fetchActivityOptions() async {
    try {
      final fetchedOptions = await ApiService.fetchActivityLevels();
      setState(() {
        activityOptions = fetchedOptions;
        isLoading = false;
      });
    } catch (e) {
      showCustomSnackBar(
        context,
        message: 'Error loading activity levels',
        icon: Icons.error_outline,
        backgroundColor: AppColors.primary1000,
      );
      setState(() => isLoading = false);
    }
  }

  Future<void> handleNext() async {
    if (selectedActivityIndex == null) {
      showCustomSnackBar(
        context,
        message: "Please select your activity level.",
        icon: Icons.error_outline,
        backgroundColor: AppColors.primary1000,
      );
      return;
    }

    final selectedId = activityOptions[selectedActivityIndex!].id;

    try {
      final message = await ApiService.submitActivityLevel(selectedId);

      showCustomSnackBar(
        context,
        message: message,
        icon: Icons.check_circle_outline,
        backgroundColor: Colors.green,
      );

      Navigator.pushReplacementNamed(context, Routes.mainHome);
    } catch (e) {
      showCustomSnackBar(
        context,
        message: "Failed to submit activity level.",
        icon: Icons.error_outline,
        backgroundColor: AppColors.primary1000,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child:
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            option.level,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.secondary1000,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            option.description,
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
