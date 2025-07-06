import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Sign in with Google
  Future<User?> signInWithGoogle() async {
    try {
      // 🔄 Optionally force sign-out for testing (uncomment during dev)
      await _googleSignIn.signOut();

      // ✅ Always show account picker (DO NOT use signInSilently)
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        debugPrint("⚠️ Google Sign-In aborted by user.");
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      debugPrint("✅ Google Sign-In successful: ${userCredential.user?.email}");
      return userCredential.user;
    } catch (e) {
      debugPrint("❌ Google Sign-In error: $e");
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    debugPrint("👋 Signed out from Google and Firebase.");
  }

  // Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
