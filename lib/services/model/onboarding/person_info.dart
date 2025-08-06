class PersonalInfoResponse {
  final bool success;
  final String message;
  final User user;

  PersonalInfoResponse({
    required this.success,
    required this.message,
    required this.user,
  });

  factory PersonalInfoResponse.fromJson(Map<String, dynamic> json) {
    return PersonalInfoResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      user: User.fromJson(json['data']?['user'] ?? {}),
    );
  }
}

class User {
  final String id;
  final String gender;
  final String age;
  final String height;
  final String weight;

  User({
    required this.id,
    required this.gender,
    required this.age,
    required this.height,
    required this.weight,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      gender: json['gender'] ?? '',
      age: json['age']?.toString() ?? '',
      height: json['height'] ?? '',
      weight: json['weight'] ?? '',
    );
  }
}
