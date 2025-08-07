import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:mood_meal/constant/api_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/auth/signUp/model/signup_user_model.dart';
import 'model/auth/signIn_model.dart';

class AuthService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  Uri _buildUrl(String endpoint) =>
      Uri.parse("${ApiConstant.baseUrl}$endpoint");

  Future<SignUpResponse?> signUp(Map<String, String> data) async {
    final uri = _buildUrl(ApiConstant.signUp);

    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 201 && responseBody["success"] == true) {
        final dataField = responseBody["data"];
        if (dataField == null ||
            dataField["token"] == null ||
            dataField["refreshToken"] == null ||
            dataField["user"] == null) {
          debugPrint("Incomplete sign-up response.");
          return null;
        }

        return SignUpResponse.fromJson(responseBody);
      }

      debugPrint('Sign-Up Failed: ${response.body}');
      return null;
    } catch (e) {
      debugPrint('Sign-Up Error: $e');
      return null;
    }
  }

  // Future<SignUpResponse?> signUp(Map<String, String> data) async {
  //   final uri = _buildUrl(ApiConstant.signUp);
  //
  //   try {
  //     final response = await http.post(
  //       uri,
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode(data),
  //     );
  //
  //     final responseBody = jsonDecode(response.body);
  //
  //     if (response.statusCode == 201 && responseBody["success"] == true) {
  //       final dataField = responseBody["data"];
  //       if (dataField == null ||
  //           dataField["token"] == null ||
  //           dataField["refreshToken"] == null ||
  //           dataField["user"] == null) {
  //         debugPrint("Incomplete sign-up response.");
  //         return null;
  //       }
  //
  //       await _saveUserSession(dataField);
  //       return SignUpResponse.fromJson(responseBody);
  //     }
  //
  //     debugPrint('Sign-Up Failed: ${response.body}');
  //     return null;
  //   } catch (e) {
  //     debugPrint('Sign-Up Error: $e');
  //     return null;
  //   }
  // }

  static Future<SignInResponse?> signIn({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('${ApiConstant.baseUrl}${ApiConstant.signIn}');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userEmail': email.toLowerCase().trim(), // normalized
          'password': password.trim(),
        }),
      );

      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        final Map<String, dynamic>? dataField = data['data'];
        if (dataField == null) {
          debugPrint("No 'data' field found in response.");
          return null;
        }

        final token = dataField['token'] as String?;
        final refreshToken = dataField['refreshToken'] as String?;

        if (token == null || refreshToken == null) {
          debugPrint("Token or refreshToken is missing.");
          return null;
        }

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('accessToken', token);
        await prefs.setString('refreshToken', refreshToken);
        await prefs.setBool('isLoggedIn', true);

        debugPrint('AuthToken: $token');

        return SignInResponse.fromJson(data);
      } else {
        final error = jsonDecode(response.body);
        print("Sign-In failed: ${error['message'] ?? 'Unknown error'}");
        return null;
      }
    } catch (e) {
      print("Error during sign-in: $e");
      return null;
    }
  }

  static Future<SignInResponse?> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;
      if (idToken == null) {
        debugPrint("Google Sign-In token missing.");
        return null;
      }

      final response = await http.post(
        Uri.parse('${ApiConstant.baseUrl}${ApiConstant.googleAuth}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'idToken': idToken}),
      );

      final body = jsonDecode(response.body);
      if (response.statusCode == 200 && body['success'] == true) {
        final data = body['data'];
        if (data == null || data['token'] == null || data['user'] == null) {
          debugPrint("Incomplete Google Sign-In response.");
          return null;
        }

        await _saveUserSession(data);
        return SignInResponse.fromJson(data);
      }

      debugPrint("Google Sign-In failed: ${response.body}");
      return null;
    } catch (e) {
      debugPrint("Google Sign-In Error: $e");
      return null;
    }
  }

  static Future<bool> sendForgotLink(String email) async {
    final url = Uri.parse('${ApiConstant.baseUrl}${ApiConstant.forgot}');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userEmail': email}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        debugPrint('Reset link failed: ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint("Forgot Password Error: $e");
      return false;
    }
  }

  static Future<void> signOut() async {
    try {
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
      }

      await _clearLocalSession();
    } catch (e) {
      debugPrint("Sign-Out Error: $e");
    }
  }

  static Future<void> _saveUserSession(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();

    final token = data['token'];
    final refreshToken = data['refreshToken'];
    final user = data['user'];

    await prefs.setString('accessToken', token);
    await prefs.setString('refreshToken', refreshToken);
    await prefs.setBool('isLoggedIn', true);

    if (user is Map<String, dynamic>) {
      await prefs.setString('userId', user['_id'] ?? '');
      await prefs.setString('userName', user['userName'] ?? '');
      await prefs.setString('userEmail', user['userEmail'] ?? '');
    }
  }

  static Future<void> _clearLocalSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  //
  // User? get currentUser => _auth.currentUser;
  //
  // //  SIGN UP
  // Future<String?> signUp({
  //   required String fullName,
  //   required String email,
  //   required String password,
  // }) async {
  //   try {
  //     UserCredential userCred = await _auth.createUserWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );
  //
  //     final userId = userCred.user!.uid;
  //
  //     // Register FCM token
  //     final fcmToken = await _getFCMToken();
  //     await _fireStore.collection('users').doc(userId).set({
  //       'fullName': fullName,
  //       'email': email,
  //       'createdAt': DateTime.now(),
  //       'lastLogin': DateTime.now(),
  //       'fcmTokens': fcmToken != null ? [fcmToken] : [],
  //     });
  //
  //     // Listen for future token refreshes
  //     _listenTokenRefresh(userId);
  //
  //     await LocalUserPrefs.saveUser(
  //       uid: userId,
  //       email: email,
  //       fullName: fullName,
  //     );
  //
  //     return null;
  //   } on FirebaseAuthException catch (e) {
  //     return e.message;
  //   } catch (e) {
  //     return 'SignUp failed: $e';
  //   }
  // }
  //
  // // LOGIN
  // Future<String?> login({
  //   required String email,
  //   required String password,
  // }) async {
  //   try {
  //     UserCredential cred = await _auth.signInWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );
  //
  //     final userId = cred.user!.uid;
  //     final fcmToken = await _getFCMToken();
  //
  //     final userRef = _fireStore.collection('users').doc(userId);
  //     final doc = await userRef.get();
  //
  //     final existingTokens = List<String>.from(doc.data()?['fcmTokens'] ?? []);
  //
  //     if (fcmToken != null && !existingTokens.contains(fcmToken)) {
  //       await userRef.update({
  //         'fcmTokens': FieldValue.arrayUnion([fcmToken]),
  //       });
  //     }
  //
  //     await userRef.update({'lastLogin': DateTime.now()});
  //
  //     _listenTokenRefresh(userId);
  //     await LocalUserPrefs.saveUser(uid: userId, email: email);
  //
  //     return null;
  //   } on FirebaseAuthException catch (e) {
  //     return e.message;
  //   } catch (e) {
  //     return 'Login failed: $e';
  //   }
  // }
  //
  // //  SIGN OUT
  // Future<void> signOut() async {
  //   await _auth.signOut();
  //   await LocalUserPrefs.clearUser();
  // }
  //
  // //  Register token manually (e.g. on app start)
  // Future<void> registerTokenIfLoggedIn() async {
  //   final user = _auth.currentUser;
  //   if (user != null) {
  //     final fcmToken = await _getFCMToken();
  //     if (fcmToken != null) {
  //       final userRef = _fireStore.collection('users').doc(user.uid);
  //       final doc = await userRef.get();
  //       final existingTokens = List<String>.from(
  //         doc.data()?['fcmTokens'] ?? [],
  //       );
  //
  //       if (!existingTokens.contains(fcmToken)) {
  //         await userRef.update({
  //           'fcmTokens': FieldValue.arrayUnion([fcmToken]),
  //         });
  //       }
  //     }
  //
  //     await _fireStore.collection('users').doc(user.uid).update({
  //       'lastLogin': DateTime.now(),
  //     });
  //
  //     _listenTokenRefresh(user.uid);
  //   }
  // }
  //
  // //  FCM Token Getter
  // Future<String?> _getFCMToken() async {
  //   try {
  //     await FirebaseMessaging.instance.requestPermission();
  //     return await FirebaseMessaging.instance.getToken();
  //   } catch (e) {
  //     print("FCM Token error: $e");
  //     return null;
  //   }
  // }
  //
  // //  FCM Token Refresh Listener
  // void _listenTokenRefresh(String userId) {
  //   FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
  //     final userRef = _fireStore.collection('users').doc(userId);
  //     final latestDoc = await userRef.get();
  //     final latestTokens = List<String>.from(
  //       latestDoc.data()?['fcmTokens'] ?? [],
  //     );
  //
  //     if (!latestTokens.contains(newToken)) {
  //       await userRef.update({
  //         'fcmTokens': FieldValue.arrayUnion([newToken]),
  //       });
  //     }
  //   });
  // }
  //
  // //  Send Reset Email
  // Future<String?> sendPasswordResetEmail(String email) async {
  //   try {
  //     await _auth.sendPasswordResetEmail(email: email);
  //     return null;
  //   } on FirebaseAuthException catch (e) {
  //     return e.message;
  //   } catch (e) {
  //     return 'Failed to send reset email: $e';
  //   }
  // }
  //
  // //  Update Password After Email Verification
  // Future<String?> updatePassword(String newPassword) async {
  //   try {
  //     final user = _auth.currentUser;
  //
  //     if (user != null) {
  //       await user.updatePassword(newPassword);
  //       await user.reload();
  //       return null;
  //     } else {
  //       return "No user is currently signed in.";
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     return e.message;
  //   } catch (e) {
  //     return 'Failed to update password: $e';
  //   }
  // }
}
