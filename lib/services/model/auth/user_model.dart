class User {
  final String id;
  final String firstName;
  final String lastName;
  final String userName;
  final String userEmail;
  final String userProfile;
  final String gender;
  final List<String> friends;
  final List<String> allergies;
  final List<dynamic> saved;
  final bool onboardingCompleted;
  final bool verified;
  final bool notifications;
  final String createdAt;
  final String updatedAt;
  final String moodGoal;
  final String age;
  final String height;
  final String weight;
  final String activityLevel;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.userEmail,
    required this.userProfile,
    required this.gender,
    required this.friends,
    required this.allergies,
    required this.saved,
    required this.onboardingCompleted,
    required this.verified,
    required this.notifications,
    required this.createdAt,
    required this.updatedAt,
    required this.moodGoal,
    required this.age,
    required this.height,
    required this.weight,
    required this.activityLevel,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      userName: json['userName'] ?? '',
      userEmail: json['userEmail'] ?? '',
      userProfile: json['userProfile'] ?? '',
      gender: json['gender'] ?? '',
      friends: List<String>.from(json['friends'] ?? []),
      allergies: List<String>.from(json['allergies'] ?? []),
      saved: json['saved'] ?? [],
      onboardingCompleted: json['onboardingCompleted'] ?? false,
      verified: json['verified'] ?? false,
      notifications: json['notifications'] ?? true,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      moodGoal: json['moodGoal'] ?? '',
      age: json['age'] ?? '',
      height: json['height'] ?? '',
      weight: json['weight'] ?? '',
      activityLevel: json['activityLevel'] ?? '',
    );
  }
}
