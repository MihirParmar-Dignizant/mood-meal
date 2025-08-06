class MoodGoal {
  final String id;
  final String name;
  final String emoji;
  final String imageUrl;
  bool isSelected;

  MoodGoal({
    required this.id,
    required this.name,
    required this.emoji,
    required this.imageUrl,
    this.isSelected = false,
  });

  factory MoodGoal.fromJson(
    Map<String, dynamic> json, {
    String? selectedMoodId,
  }) {
    return MoodGoal(
      id: json['_id'],
      name: json['name'],
      emoji: json['emoji'],
      imageUrl: json['image'],
      isSelected: selectedMoodId != null && json['_id'] == selectedMoodId,
    );
  }
}
