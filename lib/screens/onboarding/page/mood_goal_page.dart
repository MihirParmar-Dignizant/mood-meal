import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mood_meal/constant/app_image.dart';

import '../../../constant/app_colors.dart';
import '../../../services/jsonService/local_service.dart';
import '../../../services/model/emotion_model.dart';
import '../../../widget/build_button.dart';

class MoodGoalPage extends StatefulWidget {
  final VoidCallback? onNext;

  const MoodGoalPage({super.key, this.onNext});

  @override
  State<MoodGoalPage> createState() => _MoodGoalPageState();
}

class _MoodGoalPageState extends State<MoodGoalPage> {
  List<Emotion> emotions = [];
  int selectedIndex = 0;
  bool isLoading = true;

  final PageController _pageController = PageController(viewportFraction: 0.20);

  @override
  void initState() {
    super.initState();
    _loadEmotions();
  }

  Future<void> _loadEmotions() async {
    final loadedEmotions = await LocalService.fetchLocalEmotions();

    // For API
    // final loadedEmotions = await LocalService.fetchEmotions();

    setState(() {
      emotions = loadedEmotions;
      isLoading = false;
    });

    // Listen to page changes to update selectedIndex
    _pageController.addListener(() {
      final middleIndex = (_pageController.page ?? 0).round();
      if (middleIndex != selectedIndex) {
        setState(() {
          selectedIndex = middleIndex;
        });
      }
    });
  }

  void handleNext() {
    widget.onNext?.call();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

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
                      const SizedBox(height: 32),

                      const Spacer(),

                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Selected emotion large SVG
                            SvgPicture.asset(
                              emotions[selectedIndex].svgPath,
                              height: 150,
                              width: 150,
                            ),

                            const SizedBox(height: 16),

                            // Name chip
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

                      // Scroller
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
                                    1.0 -
                                    (distance * 0.5).clamp(
                                      0.0,
                                      0.5,
                                    ); // Scale down max 50%

                                return Center(
                                  child: Transform.scale(
                                    scale: scale,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      child: SvgPicture.asset(
                                        emotions[index].svgPath,
                                        height: 70,
                                        width: 70,
                                        colorFilter:
                                            distance < 0.1
                                                ? null
                                                : const ColorFilter.mode(
                                                  Colors.grey,
                                                  BlendMode.srcIn,
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

                      SvgPicture.asset(Assets.waveSvg),

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
