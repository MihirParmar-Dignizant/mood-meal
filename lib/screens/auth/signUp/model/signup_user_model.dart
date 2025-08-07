import '../../../../services/model/auth/user_model.dart';

class SignUpResponse {
  final bool success;
  final String message;
  final String token;
  final String refreshToken;
  final User user;

  SignUpResponse({
    required this.success,
    required this.message,
    required this.token,
    required this.refreshToken,
    required this.user,
  });

  factory SignUpResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return SignUpResponse(
      success: json['success'],
      message: json['message'],
      token: data['token'],
      refreshToken: data['refreshToken'],
      user: User.fromJson(data['user']),
    );
  }
}
