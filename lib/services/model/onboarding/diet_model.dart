class DietOption {
  final String id; // Add ID for PUT API
  final String name;
  final String iconUrl;
  bool isSelected;

  DietOption({
    required this.id,
    required this.name,
    required this.iconUrl,
    this.isSelected = false,
  });

  factory DietOption.fromJson(Map<String, dynamic> json) {
    return DietOption(
      id: json['_id'].toString(), // Make sure this matches your API response
      name: json['name'],
      iconUrl: json['img'],
    );
  }
}
