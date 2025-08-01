class Allergen {
  final String name;
  final String image;
  bool isSelected;

  Allergen({required this.name, required this.image, this.isSelected = false});

  factory Allergen.fromJson(Map<String, dynamic> json) {
    return Allergen(
      name: json['name'],
      image: json['image'],
      isSelected: json['isSelected'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'image': image, 'isSelected': isSelected};
  }
}
