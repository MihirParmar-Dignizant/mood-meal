class DietOption {
  final String name;
  final String iconUrl;
  bool isSelected;

  DietOption({
    required this.name,
    required this.iconUrl,
    this.isSelected = false,
  });

  factory DietOption.fromJson(Map<String, dynamic> json) {
    return DietOption(name: json['name'], iconUrl: json['iconUrl']);
  }
}
