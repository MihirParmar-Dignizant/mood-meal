import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constant/app_colors.dart';
import '../../../services/jsonService/local_service.dart';
import '../../../services/model/diet_model.dart';
import '../../../widget/build_button.dart';
import '../../../widget/snackBar.dart';

class DietTypePage extends StatefulWidget {
  final VoidCallback? onNext;

  const DietTypePage({super.key, this.onNext});

  @override
  State<DietTypePage> createState() => _DietTypePageState();
}

class _DietTypePageState extends State<DietTypePage> {
  List<DietOption> dietOptions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadOptions();
  }

  Future<void> loadOptions() async {
    try {
      final data = await LocalService.fetchLocalDietOptions();

      // Use this fetching from API:
      // final data = await ApiService.fetchDietOptions();

      setState(() {
        dietOptions = data;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error loading diet options: $e");
      setState(() => isLoading = false);
    }
  }

  void toggleSelection(int index) {
    setState(() {
      dietOptions[index].isSelected = !dietOptions[index].isSelected;
    });
  }

  void handleNext() {
    final selected = dietOptions.any((item) => item.isSelected);

    if (!selected) {
      showCustomSnackBar(
        context,
        message: "Please select at least one diet type",
        icon: Icons.error_outline,
        backgroundColor: AppColors.primary1000,
      );
      return;
    }

    // Callback to parent
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
                        "Choose Your Perfect Diet Type",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.secondary1000,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Find the diet that suits your health goals.",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.secondary400,
                        ),
                      ),
                      const SizedBox(height: 24),

                      Expanded(
                        child: SingleChildScrollView(
                          child: Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: List.generate(dietOptions.length, (
                              index,
                            ) {
                              final item = dietOptions[index];

                              return ChoiceChip(
                                labelPadding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                  horizontal: 10,
                                ),
                                avatar: SvgPicture.asset(
                                  item.iconUrl,
                                  width: 20,
                                  height: 20,
                                  placeholderBuilder:
                                      (BuildContext context) => const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                AppColors.primary1000,
                                              ),
                                        ),
                                      ),
                                ),

                                label: Text(item.name),
                                selected: item.isSelected,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: BorderSide(
                                    color:
                                        item.isSelected
                                            ? AppColors.primary1000
                                            : AppColors.secondary200,
                                    width: 1,
                                  ),
                                ),
                                selectedColor: AppColors.primary100,
                                backgroundColor: AppColors.white,
                                showCheckmark: false,
                                labelStyle: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.secondary900,
                                  fontWeight: FontWeight.w500,
                                ),
                                onSelected: (_) => toggleSelection(index),
                              );
                            }),
                          ),
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
