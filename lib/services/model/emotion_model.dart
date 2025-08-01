class Emotion {
  final int id;
  final String name;
  final String svgPath;
  bool isSelected;

  Emotion({
    required this.id,
    required this.name,
    required this.svgPath,
    this.isSelected = false,
  });

  factory Emotion.fromJson(Map<String, dynamic> json) {
    return Emotion(
      id: json['id'],
      name: json['name'],
      svgPath: json['svgPath'],
    );
  }
}
