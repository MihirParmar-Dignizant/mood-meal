import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constant/app_colors.dart';
import '../../../constant/app_image.dart';
import '../../../services/jsonService/local_service.dart';
import '../../../services/model/allergen_model.dart';
import '../../../widget/build_button.dart';
import '../../../widget/snackBar.dart';

class FoodAllergiesPage extends StatefulWidget {
  final VoidCallback? onNext;

  const FoodAllergiesPage({super.key, this.onNext});

  @override
  State<FoodAllergiesPage> createState() => _FoodAllergiesPageState();
}

class _FoodAllergiesPageState extends State<FoodAllergiesPage> {
  bool isLoading = true;
  List<Allergen> allergens = [];

  @override
  void initState() {
    super.initState();
    loadAllergens();
  }

  Future<void> loadAllergens() async {
    allergens = await LocalService.fetchLocalAllergens();

    // Use this fetching from API:
    // allergens = await ApiService.fetchAllergens();

    setState(() {
      isLoading = false;
    });
  }

  void handleNext() {
    final selected = allergens.any((item) => item.isSelected);
    if (!selected) {
      showCustomSnackBar(
        context,
        message: "Please select at least one allergy",
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
                      // Header
                      Text(
                        "Choose Your Food Allergies",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.secondary1000,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Select allergens to customize your meals.",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.secondary400,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Allergen List
                      Expanded(
                        child: ListView.builder(
                          itemCount: allergens.length,
                          itemBuilder: (context, index) {
                            final allergen = allergens[index];
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  allergen.isSelected = !allergen.isSelected;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      allergen.isSelected
                                          ? const Color(0xFFFFF5F0)
                                          : Colors.white,
                                  border: Border.all(
                                    color:
                                        allergen.isSelected
                                            ? AppColors.primary1000
                                            : AppColors.secondary100,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.asset(
                                        allergen.image,
                                        width: 45,
                                        height: 45,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        allergen.name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    SvgPicture.asset(
                                      allergen.isSelected
                                          ? Assets
                                              .checkedSvg // e.g. orange check icon
                                          : Assets.uncheckedSvg,
                                      // e.g. outlined gray box
                                      width: 24,
                                      height: 24,
                                      // REMOVE colorFilter to use SVG's default color
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
