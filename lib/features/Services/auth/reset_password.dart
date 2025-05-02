import 'package:firebase_auth/firebase_auth.dart';

class ResetPassword {
  Future<void> reset(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim());
    } catch (e) {
      rethrow;
    }
  }
}