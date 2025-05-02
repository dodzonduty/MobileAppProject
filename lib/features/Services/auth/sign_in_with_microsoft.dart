import 'package:firebase_auth/firebase_auth.dart';

class SignInWithMicrosoft {
  Future<UserCredential?> signIn() async {
    try {
      final provider = OAuthProvider('microsoft.com');
      provider.setCustomParameters({
        'prompt': 'login',
        'tenant': '49fec46f-5c8a-405f-8772-a755acd6364a',
      });
      provider.addScope('User.Read openid profile email');
      final userCredential = await FirebaseAuth.instance.signInWithProvider(provider);
      print('Microsoft login successful: ${userCredential.user?.email}');
      print('User credential: $userCredential');

      final email = userCredential.user?.email;
      if (email != null && !email.endsWith('@feng.bu.edu.eg')) {
        print('Invalid email domain: $email');
        await FirebaseAuth.instance.signOut();
        throw FirebaseAuthException(
          code: 'invalid-email-domain',
          message: 'Only @feng.bu.edu.eg email addresses are allowed.',
        );
      }
      return userCredential;
    } catch (e) {
      print('Microsoft login error: $e');
      rethrow;
    }
  }
}