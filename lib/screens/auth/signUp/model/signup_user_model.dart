class SignUpUserModel {
  final String firstName;
  final String lastName;
  final String userName;
  final String userEmail;
  final String password;

  SignUpUserModel({
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.userEmail,
    required this.password,
  });

  Map<String, String> toMap() {
    return {
      "firstName": firstName,
      "lastName": lastName,
      "userName": userName,
      "userEmail": userEmail,
      "password": password,
    };
  }
}
