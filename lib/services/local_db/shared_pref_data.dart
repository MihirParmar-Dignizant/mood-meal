import 'package:shared_preferences/shared_preferences.dart';

class LocalUserPrefs {
  static const String _keyUid = 'uid';
  static const String _keyEmail = 'email';
  static const String _keyFullName = 'fullName';
  static const String _keyIsLoggedIn = 'isLoggedIn';

  // Save user
  static Future<void> saveUser({
    required String uid,
    required String email,
    String? fullName,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUid, uid);
    await prefs.setString(_keyEmail, email);
    await prefs.setString(_keyFullName, fullName ?? "");
    await prefs.setBool(_keyIsLoggedIn, true); // Mark user as logged in
  }

  // Get user
  static Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString(_keyUid);
    final email = prefs.getString(_keyEmail);
    final fullName = prefs.getString(_keyFullName);
    final isLoggedIn = prefs.getBool(_keyIsLoggedIn) ?? false;

    if (uid != null && email != null && fullName != null && isLoggedIn) {
      return {
        'uid': uid,
        'email': email,
        'fullName': fullName,
        'isLoggedIn': isLoggedIn,
      };
    }
    return null;
  }

  // Check login status
  static Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  // Clear user
  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUid);
    await prefs.remove(_keyEmail);
    await prefs.remove(_keyFullName);
    await prefs.setBool(_keyIsLoggedIn, false);
  }
}
