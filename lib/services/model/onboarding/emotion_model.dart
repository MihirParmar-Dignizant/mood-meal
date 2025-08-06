class MoodGoal {
  final String id;
  final String name;
  final String emoji; // actual image URL
  bool isSelected;

  MoodGoal({
    required this.id,
    required this.name,
    required this.emoji,
    this.isSelected = false,
  });

  factory MoodGoal.fromJson(
    Map<String, dynamic> json, {
    String? selectedMoodId,
  }) {
    final String id = json['_id']?.toString() ?? '';
    final String name = json['name']?.toString() ?? '';
    final String emoji = json['emoji']?.toString() ?? '';

    return MoodGoal(
      id: id,
      name: name,
      emoji: emoji,
      isSelected: selectedMoodId != null && id == selectedMoodId,
    );
  }
}
