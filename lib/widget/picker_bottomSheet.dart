import 'package:flutter/material.dart';

import '../constant/app_colors.dart';
import 'build_button.dart';

Future<void> showCustomPickerBottomSheet({
  required BuildContext context,
  required String title,
  required List<String> items,
  required ValueChanged<String> onItemSelected,
  String unit = '',
  int initialIndex = 50,
  bool isDualPicker = false,
  List<String>? secondItems,
  String secondUnit = '',
  int initialSecondIndex = 0,
  ValueChanged<String>? onSecondItemSelected,

  // For cm/ft-in toggle case
  bool showUnitToggle = false,
  ValueChanged<String>? onItemSelectedCm,
  ValueChanged<List<String>>? onItemSelectedFtIn,
}) {
  int selectedIndex = initialIndex;
  int selectedSecondIndex = initialSecondIndex;

  // ft-in mode
  bool isCm = true;
  List<String> cmItems = items;
  List<String> ftItems = List.generate(8, (i) => (3 + i).toString()); // 3–10 ft
  List<String> inItems = List.generate(12, (i) => i.toString()); // 0–11 in
  int selectedFtIndex = 2;
  int selectedInIndex = 6;

  final firstController = FixedExtentScrollController(
    initialItem: initialIndex,
  );
  final secondController =
      isDualPicker
          ? FixedExtentScrollController(initialItem: initialSecondIndex)
          : null;
  final ftController = FixedExtentScrollController(
    initialItem: selectedFtIndex,
  );
  final inController = FixedExtentScrollController(
    initialItem: selectedInIndex,
  );

  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder:
            (context, setState) => SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// Handle
                    Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),

                    /// Title + Close
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    /// Toggle for cm/ft-in
                    if (showUnitToggle)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ChoiceChip(
                            label: const Text('cm'),
                            selected: isCm,
                            onSelected: (selected) {
                              setState(() {
                                isCm = true;
                              });
                            },
                            selectedColor: AppColors.primary1000.withOpacity(
                              0.05,
                            ),
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color:
                                    isCm
                                        ? AppColors.primary1000
                                        : Colors.grey.shade300,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            labelStyle: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                            showCheckmark: false,
                          ),
                          const SizedBox(width: 12),
                          ChoiceChip(
                            label: const Text('ft/in'),
                            selected: !isCm,
                            onSelected: (selected) {
                              setState(() {
                                isCm = false;
                              });
                            },
                            selectedColor: AppColors.primary1000.withOpacity(
                              0.05,
                            ),
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color:
                                    !isCm
                                        ? AppColors.primary1000
                                        : Colors.grey.shade300,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            labelStyle: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                            showCheckmark: false,
                          ),
                        ],
                      ),

                    if (showUnitToggle) const SizedBox(height: 16),

                    /// Picker(s)
                    SizedBox(
                      height: 200,
                      width: isDualPicker ? 300 : 150,
                      child: Stack(
                        children: [
                          if (!showUnitToggle || isCm)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: ListWheelScrollView.useDelegate(
                                    controller: firstController,
                                    itemExtent: 60,
                                    physics: const FixedExtentScrollPhysics(),
                                    onSelectedItemChanged: (index) {
                                      selectedIndex = index;
                                    },
                                    childDelegate: ListWheelChildBuilderDelegate(
                                      childCount: cmItems.length,
                                      builder: (context, index) {
                                        if (index < 0 ||
                                            index >= cmItems.length)
                                          return null;
                                        return AnimatedBuilder(
                                          animation: firstController,
                                          builder: (context, child) {
                                            final selected =
                                                firstController.selectedItem ==
                                                index;
                                            return Center(
                                              child: Text(
                                                selected
                                                    ? '${cmItems[index]} $unit'
                                                    : cmItems[index],
                                                style: TextStyle(
                                                  fontSize: selected ? 20 : 16,
                                                  fontWeight:
                                                      selected
                                                          ? FontWeight.w600
                                                          : FontWeight.normal,
                                                  color:
                                                      selected
                                                          ? Colors.black
                                                          : AppColors
                                                              .secondary500,
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                if (isDualPicker && secondItems != null)
                                  const SizedBox(width: 20),
                                if (isDualPicker && secondItems != null)
                                  Expanded(
                                    child: ListWheelScrollView.useDelegate(
                                      controller: secondController!,
                                      itemExtent: 60,
                                      physics: const FixedExtentScrollPhysics(),
                                      onSelectedItemChanged: (index) {
                                        selectedSecondIndex = index;
                                      },
                                      childDelegate: ListWheelChildBuilderDelegate(
                                        childCount: secondItems.length,
                                        builder: (context, index) {
                                          if (index < 0 ||
                                              index >= secondItems.length)
                                            return null;
                                          return AnimatedBuilder(
                                            animation: secondController,
                                            builder: (context, child) {
                                              final selected =
                                                  secondController
                                                      .selectedItem ==
                                                  index;
                                              return Center(
                                                child: Text(
                                                  selected
                                                      ? '${secondItems[index]} $secondUnit'
                                                      : secondItems[index],
                                                  style: TextStyle(
                                                    fontSize:
                                                        selected ? 20 : 16,
                                                    fontWeight:
                                                        selected
                                                            ? FontWeight.w600
                                                            : FontWeight.normal,
                                                    color:
                                                        selected
                                                            ? Colors.black
                                                            : AppColors
                                                                .secondary500,
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                              ],
                            )
                          else
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: ListWheelScrollView.useDelegate(
                                    controller: ftController,
                                    itemExtent: 60,
                                    physics: const FixedExtentScrollPhysics(),
                                    onSelectedItemChanged: (index) {
                                      selectedFtIndex = index;
                                    },
                                    childDelegate:
                                        ListWheelChildBuilderDelegate(
                                          childCount: ftItems.length,
                                          builder: (context, index) {
                                            final selected =
                                                ftController.selectedItem ==
                                                index;
                                            return Center(
                                              child: Text(
                                                selected
                                                    ? '${ftItems[index]} ft'
                                                    : ftItems[index],
                                                style: TextStyle(
                                                  fontSize: selected ? 20 : 16,
                                                  fontWeight:
                                                      selected
                                                          ? FontWeight.w600
                                                          : FontWeight.normal,
                                                  color:
                                                      selected
                                                          ? Colors.black
                                                          : AppColors
                                                              .secondary500,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: ListWheelScrollView.useDelegate(
                                    controller: inController,
                                    itemExtent: 60,
                                    physics: const FixedExtentScrollPhysics(),
                                    onSelectedItemChanged: (index) {
                                      selectedInIndex = index;
                                    },
                                    childDelegate:
                                        ListWheelChildBuilderDelegate(
                                          childCount: inItems.length,
                                          builder: (context, index) {
                                            final selected =
                                                inController.selectedItem ==
                                                index;
                                            return Center(
                                              child: Text(
                                                selected
                                                    ? '${inItems[index]} in'
                                                    : inItems[index],
                                                style: TextStyle(
                                                  fontSize: selected ? 20 : 16,
                                                  fontWeight:
                                                      selected
                                                          ? FontWeight.w600
                                                          : FontWeight.normal,
                                                  color:
                                                      selected
                                                          ? Colors.black
                                                          : AppColors
                                                              .secondary500,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                  ),
                                ),
                              ],
                            ),

                          /// Highlight middle selection bar
                          Positioned.fill(
                            child: IgnorePointer(
                              child: Center(
                                child: Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    border: Border.symmetric(
                                      horizontal: BorderSide(
                                        color: AppColors.secondary100,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// Done Button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: buildButton(
                        text: "Done",
                        onPressed: () {
                          if (showUnitToggle) {
                            if (isCm) {
                              onItemSelectedCm?.call(cmItems[selectedIndex]);
                            } else {
                              onItemSelectedFtIn?.call([
                                ftItems[selectedFtIndex],
                                inItems[selectedInIndex],
                              ]);
                            }
                          } else {
                            onItemSelected(items[selectedIndex]);
                            if (isDualPicker &&
                                secondItems != null &&
                                onSecondItemSelected != null) {
                              onSecondItemSelected(
                                secondItems[selectedSecondIndex],
                              );
                            }
                          }
                          Navigator.of(context).pop();
                        },
                        backgroundColor: AppColors.primary1000,
                        textColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
      );
    },
  );
}
