import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  Future<String?> sendResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'Ocurrió un error';
    }
  }
}
