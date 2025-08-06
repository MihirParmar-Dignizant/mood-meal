import 'package:flutter/material.dart';

import '../../../constant/app_colors.dart';
import '../../../services/api/api_services.dart';
import '../../../services/model/onboarding/diet_model.dart';
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
  Set<String> selectedIds = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadOptions();
  }

  Future<void> loadOptions() async {
    try {
      final data = await ApiService.fetchDietOptions();
      final storedIds =
          await ApiService.getSavedDietSelections(); // your API call to load previously saved IDs

      setState(() {
        dietOptions =
            data.map((option) {
              return DietOption(
                id: option.id,
                name: option.name,
                iconUrl: option.iconUrl,
                isSelected: storedIds.contains(option.id),
              );
            }).toList();

        selectedIds = storedIds.toSet();
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error loading diet options: $e");
      if (context.mounted) {
        showCustomSnackBar(
          context,
          message: "Failed to load diet options",
          icon: Icons.error_outline,
          backgroundColor: Colors.red,
        );
      }
      setState(() => isLoading = false);
    }
  }

  void toggleSelection(String id) {
    setState(() {
      if (selectedIds.contains(id)) {
        selectedIds.remove(id);
      } else {
        selectedIds.add(id);
      }

      for (var option in dietOptions) {
        option.isSelected = selectedIds.contains(option.id);
      }
    });
  }

  void handleNext() async {
    if (selectedIds.isEmpty) {
      showCustomSnackBar(
        context,
        message: "Please select at least one diet type",
        icon: Icons.error_outline,
        backgroundColor: AppColors.primary1000,
      );
      return;
    }

    try {
      await ApiService.saveSelectedDiets(selectedIds.toList());
      widget.onNext?.call();
    } catch (e) {
      debugPrint("Error saving diet: $e");
      if (context.mounted) {
        showCustomSnackBar(
          context,
          message: "Failed to save selection",
          icon: Icons.error_outline,
          backgroundColor: Colors.red,
        );
      }
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
                  ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary1000,
                    ),
                  )
                  : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                            children:
                                dietOptions.map((item) {
                                  return ChoiceChip(
                                    labelPadding: const EdgeInsets.symmetric(
                                      vertical: 4,
                                      horizontal: 10,
                                    ),
                                    avatar: Image.network(
                                      item.iconUrl,
                                      width: 20,
                                      height: 20,
                                      loadingBuilder: (
                                        context,
                                        child,
                                        progress,
                                      ) {
                                        if (progress == null) return child;
                                        return const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  AppColors.primary1000,
                                                ),
                                          ),
                                        );
                                      },
                                      errorBuilder:
                                          (_, __, ___) => const Icon(
                                            Icons.broken_image,
                                            size: 20,
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
                                    onSelected: (_) => toggleSelection(item.id),
                                  );
                                }).toList(),
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

  // @override
  bool get wantKeepAlive => true;
}
