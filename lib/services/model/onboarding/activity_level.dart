class ActivityLevel {
  final String id;
  final String level;
  final String description;

  ActivityLevel({
    required this.id,
    required this.level,
    required this.description,
  });

  factory ActivityLevel.fromJson(Map<String, dynamic> json) {
    return ActivityLevel(
      id: json['_id'],
      level: json['level'],
      description: json['description'],
    );
  }
}
