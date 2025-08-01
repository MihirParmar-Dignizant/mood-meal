import 'package:flutter/material.dart';
import 'package:mood_meal/constant/app_colors.dart';
import 'package:mood_meal/screens/onboarding/page/diet_type_page.dart';
import 'package:mood_meal/screens/onboarding/page/food_allergie_page.dart';
import 'package:mood_meal/screens/onboarding/page/mood_goal_page.dart';
import 'package:mood_meal/screens/onboarding/page/personal_info_activity.dart';
import 'package:mood_meal/screens/onboarding/page/personal_info_page.dart';

import '../../widget/app_bar.dart';

class DietaryPrefScreen extends StatefulWidget {
  const DietaryPrefScreen({Key? key}) : super(key: key);

  @override
  State<DietaryPrefScreen> createState() => _DietaryPrefScreenState();
}

class _DietaryPrefScreenState extends State<DietaryPrefScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<String> _titles = [
    'Dietary Preferences',
    'Dietary Preferences',
    'Mood Goal',
    'Personal Information',
    'Personal Information',
  ];

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      DietTypePage(onNext: nextPage),
      FoodAllergiesPage(onNext: nextPage),
      MoodGoalPage(onNext: nextPage),
      PersonalInfoPage(onNext: nextPage),
      PersonalInfoActivityPage(onNext: nextPage),
    ];

    _pageController.addListener(() {
      final newPage = _pageController.page?.round() ?? 0;
      if (newPage != _currentPage) {
        setState(() => _currentPage = newPage);
      }
    });
  }

  void nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      debugPrint("Onboarding Complete");
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _currentPage == 0,
      onPopInvokedWithResult: (didPop, context) {
        if (!didPop && _currentPage > 0) {
          _pageController.previousPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: CustomTopAppBar(
          isImage: false,
          label: _titles[_currentPage],
          showBackButton: true,
          onBack: () {
            if (_currentPage > 0) {
              _pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            } else {
              Navigator.pop(context);
            }
          },
          backgroundColor: AppColors.white,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: List.generate(_pages.length, (index) {
                  final isCompleted = index <= _currentPage;
                  return Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color:
                            isCompleted
                                ? AppColors.primary1000
                                : AppColors.secondary200,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _pages.length,
                itemBuilder: (_, index) => _pages[index],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
