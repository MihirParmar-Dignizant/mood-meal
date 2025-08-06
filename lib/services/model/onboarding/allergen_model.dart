class Allergen {
  final String id;
  final String name;
  final String image;
  bool isSelected;

  Allergen({
    required this.id,
    required this.name,
    required this.image,
    this.isSelected = false,
  });

  factory Allergen.fromJson(Map<String, dynamic> json) {
    return Allergen(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      image: json['img'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name, 'image': image, 'isSelected': isSelected};
  }
}
