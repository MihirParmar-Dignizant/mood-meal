// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
//
// import 'local_db/shared_pref_data.dart';
//
// class AuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
//
//   User? get currentUser => _auth.currentUser;
//
//   // 🔐 SIGN UP
//   Future<String?> signUp({
//     required String fullName,
//     required String email,
//     required String password,
//   }) async {
//     try {
//       UserCredential userCred = await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//
//       final userId = userCred.user!.uid;
//
//       // Register FCM token
//       final fcmToken = await _getFCMToken();
//       await _fireStore.collection('users').doc(userId).set({
//         'fullName': fullName,
//         'email': email,
//         'createdAt': DateTime.now(),
//         'lastLogin': DateTime.now(),
//         'fcmTokens': fcmToken != null ? [fcmToken] : [],
//       });
//
//       // Listen for future token refreshes
//       _listenTokenRefresh(userId);
//
//       await LocalUserPrefs.saveUser(
//         uid: userId,
//         email: email,
//         fullName: fullName,
//       );
//
//       return null;
//     } on FirebaseAuthException catch (e) {
//       return e.message;
//     } catch (e) {
//       return 'SignUp failed: $e';
//     }
//   }
//
//   // 🔐 LOGIN
//   Future<String?> login({
//     required String email,
//     required String password,
//   }) async {
//     try {
//       UserCredential cred = await _auth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//
//       final userId = cred.user!.uid;
//       final fcmToken = await _getFCMToken();
//
//       final userRef = _fireStore.collection('users').doc(userId);
//       final doc = await userRef.get();
//
//       final existingTokens = List<String>.from(doc.data()?['fcmTokens'] ?? []);
//
//       if (fcmToken != null && !existingTokens.contains(fcmToken)) {
//         await userRef.update({
//           'fcmTokens': FieldValue.arrayUnion([fcmToken]),
//         });
//       }
//
//       await userRef.update({'lastLogin': DateTime.now()});
//
//       _listenTokenRefresh(userId);
//       await LocalUserPrefs.saveUser(uid: userId, email: email);
//
//       return null;
//     } on FirebaseAuthException catch (e) {
//       return e.message;
//     } catch (e) {
//       return 'Login failed: $e';
//     }
//   }
//
//   // 🔓 SIGN OUT
//   Future<void> signOut() async {
//     await _auth.signOut();
//     await LocalUserPrefs.clearUser();
//   }
//
//   // ✅ Register token manually (e.g. on app start)
//   Future<void> registerTokenIfLoggedIn() async {
//     final user = _auth.currentUser;
//     if (user != null) {
//       final fcmToken = await _getFCMToken();
//       if (fcmToken != null) {
//         final userRef = _fireStore.collection('users').doc(user.uid);
//         final doc = await userRef.get();
//         final existingTokens = List<String>.from(
//           doc.data()?['fcmTokens'] ?? [],
//         );
//
//         if (!existingTokens.contains(fcmToken)) {
//           await userRef.update({
//             'fcmTokens': FieldValue.arrayUnion([fcmToken]),
//           });
//         }
//       }
//
//       await _fireStore.collection('users').doc(user.uid).update({
//         'lastLogin': DateTime.now(),
//       });
//
//       _listenTokenRefresh(user.uid);
//     }
//   }
//
//   // 📦 FCM Token Getter
//   Future<String?> _getFCMToken() async {
//     try {
//       await FirebaseMessaging.instance.requestPermission();
//       return await FirebaseMessaging.instance.getToken();
//     } catch (e) {
//       print("FCM Token error: $e");
//       return null;
//     }
//   }
//
//   // 🔁 FCM Token Refresh Listener
//   void _listenTokenRefresh(String userId) {
//     FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
//       final userRef = _fireStore.collection('users').doc(userId);
//       final latestDoc = await userRef.get();
//       final latestTokens = List<String>.from(
//         latestDoc.data()?['fcmTokens'] ?? [],
//       );
//
//       if (!latestTokens.contains(newToken)) {
//         await userRef.update({
//           'fcmTokens': FieldValue.arrayUnion([newToken]),
//         });
//       }
//     });
//   }
//
//   // 📧 Send Reset Email
//   Future<String?> sendPasswordResetEmail(String email) async {
//     try {
//       await _auth.sendPasswordResetEmail(email: email);
//       return null;
//     } on FirebaseAuthException catch (e) {
//       return e.message;
//     } catch (e) {
//       return 'Failed to send reset email: $e';
//     }
//   }
//
//   // 🔑 Update Password After Email Verification
//   Future<String?> updatePassword(String newPassword) async {
//     try {
//       final user = _auth.currentUser;
//
//       if (user != null) {
//         await user.updatePassword(newPassword);
//         await user.reload();
//         return null;
//       } else {
//         return "No user is currently signed in.";
//       }
//     } on FirebaseAuthException catch (e) {
//       return e.message;
//     } catch (e) {
//       return 'Failed to update password: $e';
//     }
//   }
// }
