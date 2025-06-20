import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  Future<String?> sendResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: email,
        actionCodeSettings: ActionCodeSettings(
          url: 'https://creativo-679b2.web.app/chenge-password',
          handleCodeInApp: false,
        ),
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'Ocurrió un error';
    }
  }

  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null && !user.emailVerified) {
      try {
        await user.sendEmailVerification();
      } catch (e) {
        debugPrint('❌ Error sending verification email: $e');
      }
    } else {
      debugPrint('⚠️ User is null or already verified.');
    }
  }
}
