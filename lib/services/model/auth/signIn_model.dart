import 'package:mood_meal/services/model/auth/user_model.dart';

class SignInResponse {
  final String token;
  final String refreshToken;
  final User user;

  SignInResponse({
    required this.token,
    required this.refreshToken,
    required this.user,
  });

  factory SignInResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return SignInResponse(
      token: data['token'],
      refreshToken: data['refreshToken'],
      user: User.fromJson(data['user']),
    );
  }
}
