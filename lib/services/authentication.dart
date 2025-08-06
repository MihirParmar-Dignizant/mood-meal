import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:mood_meal/constant/api_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/auth/signIn_model.dart';

class AuthService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  Uri _buildUrl(String endpoint) {
    return Uri.parse("${ApiConstant.baseUrl}$endpoint");
  }

  // Signs up the user using provided data.
  // Returns `null` if successful, otherwise returns an error message.
  Future<String?> signUp(Map<String, String> data) async {
    try {
      final uri = _buildUrl(ApiConstant.signUp);

      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      final Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 201 && responseBody["success"] == true) {
        // TODO: Save tokens or user info if needed
        return null;
      } else {
        return responseBody['message'] ?? "Unknown error occurred";
      }
    } catch (e) {
      return "An error occurred: $e";
    }
  }

  static Future<SignInResponse?> signIn({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('${ApiConstant.baseUrl}${ApiConstant.signIn}');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userEmail': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('accessToken', data['data']['token']);
        await prefs.setBool('isLoggedIn', true);

        String authToken = prefs.getString('accessToken') ?? '';
        debugPrint('AuthToken:   $authToken');

        return SignInResponse.fromJson(data);
      } else {
        print("Sign-In failed: ${response.body}");
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
      if (googleUser == null) {
        print('Google Sign-In canceled');
        return null;
      }
      final googleAuth = await googleUser.authentication;

      final idToken = googleAuth.idToken;
      if (idToken == null) {
        print("Failed to retrieve Token");
        return null;
      }

      final response = await http.post(
        Uri.parse('${ApiConstant.baseUrl}${ApiConstant.googleAuth}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'idToken': idToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return SignInResponse.fromJson(data);
      } else {
        print("Google Auth Api failed: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Google Sign-In error: $e");
      return null;
    }
  }

  static Future<void> signOut() async {
    try {
      final isGoogleSignedIn = await _googleSignIn.isSignedIn();
      if (isGoogleSignedIn) {
        await _googleSignIn.signOut();
        print("Google user Signed Out");
      }

      await _clearLocalSession();
      print("Local session cleared (email/password).");
    } catch (e) {
      print("Error during sign-out: $e");
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
        print("Forgot Link send successfully.");
        return true;
      } else {
        print('Failed to send reset link: ${response.body}');
        return false;
      }
    } catch (e) {
      print("Error sending to forgot password link: $e");
      return false;
    }
  }

  static Future<void> _clearLocalSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // or use prefs.remove('key') if selective
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
