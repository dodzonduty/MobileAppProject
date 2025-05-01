import 'package:firebase_auth/firebase_auth.dart';
class SignInWithEmail {
  Future<UserCredential?> signIn(String email, String password) async {
    try {
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return userCredential;
    } catch (e) {
      rethrow;
    }
  }
}