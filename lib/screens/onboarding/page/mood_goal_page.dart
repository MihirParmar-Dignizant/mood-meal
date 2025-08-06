import 'package:flutter/material.dart';

import '../../../constant/app_colors.dart';
import '../../../services/api/api_services.dart';
import '../../../services/model/onboarding/emotion_model.dart';
import '../../../widget/build_button.dart';

class MoodGoalPage extends StatefulWidget {
  final VoidCallback? onNext;

  const MoodGoalPage({super.key, this.onNext});

  @override
  State<MoodGoalPage> createState() => _MoodGoalPageState();
}

class _MoodGoalPageState extends State<MoodGoalPage> {
  List<MoodGoal> emotions = [];
  int selectedIndex = 0;
  bool isLoading = true;

  final PageController _pageController = PageController(viewportFraction: 0.20);

  @override
  void initState() {
    super.initState();
    _loadEmotions();
  }

  Future<void> _loadEmotions() async {
    try {
      final loadedEmotions = await ApiService.fetchMoodGoals();
      setState(() {
        emotions = loadedEmotions;
        selectedIndex = loadedEmotions.indexWhere((e) => e.isSelected);
        if (selectedIndex == -1) selectedIndex = 0;
        isLoading = false;
      });

      _pageController.addListener(() {
        final middleIndex = (_pageController.page ?? 0).round();
        if (middleIndex != selectedIndex) {
          setState(() {
            selectedIndex = middleIndex;
          });
        }
      });
    } catch (e) {
      debugPrint("Error loading emotions: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void handleNext() {
    // You can pass the selected mood object to the next step here if needed
    final selectedMood = emotions[selectedIndex];
    debugPrint("Selected Mood: ${selectedMood.name}");
    widget.onNext?.call();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
                  ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary1000,
                    ),
                  )
                  : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "How Are You Feeling Today?",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.secondary1000,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Select a mood to customize your journey.",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.secondary400,
                        ),
                      ),
                      const SizedBox(height: 32),
                      const Spacer(),

                      // Centered selected mood
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.network(
                              emotions[selectedIndex].emoji,
                              height: 150,
                              width: 150,
                              errorBuilder:
                                  (_, __, ___) => const Icon(Icons.error),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.primary100,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppColors.primary1000,
                                  width: 1.5,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 8,
                              ),
                              child: Text(
                                emotions[selectedIndex].name,
                                style: TextStyle(
                                  color: AppColors.secondary1000,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Spacer(),

                      // Horizontal scroll mood list
                      SizedBox(
                        height: 85,
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: emotions.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return AnimatedBuilder(
                              animation: _pageController,
                              builder: (context, child) {
                                double currentPage = 0;

                                if (_pageController.hasClients) {
                                  currentPage =
                                      _pageController.page ??
                                      _pageController.initialPage.toDouble();
                                }

                                final distance = (index - currentPage).abs();
                                final scale =
                                    1.0 - (distance * 0.5).clamp(0.0, 0.5);

                                return Center(
                                  child: Transform.scale(
                                    scale: scale,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      child: ColorFiltered(
                                        colorFilter:
                                            distance < 0.1
                                                ? const ColorFilter.mode(
                                                  Colors.transparent,
                                                  BlendMode.multiply,
                                                )
                                                : const ColorFilter.mode(
                                                  Colors.transparent,
                                                  BlendMode.saturation,
                                                ),
                                        child: Image.network(
                                          emotions[index].emoji,
                                          height: 70,
                                          width: 70,
                                          errorBuilder:
                                              (_, __, ___) =>
                                                  const Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 32),

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
