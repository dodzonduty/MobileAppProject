import 'package:firebase_auth/firebase_auth.dart';
import 'sign_in_with_email.dart';
import 'sign_up_with_email.dart';
import 'sign_in_with_microsoft.dart';
import 'reset_password.dart';

class AuthService {
  final SignInWithEmail _emailSignIn = SignInWithEmail();
  final SignUpWithEmail _emailSignUp = SignUpWithEmail();
  final SignInWithMicrosoft _microsoftSignIn = SignInWithMicrosoft();
  final ResetPassword _resetPassword = ResetPassword();

  Future<UserCredential?> signInWithEmail(String email, String password) =>
      _emailSignIn.signIn(email, password);

  Future<UserCredential?> signUpWithEmail({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phoneNumber,
  }) =>
      _emailSignUp.signUp(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
      );

  Future<UserCredential?> signInWithMicrosoft() => _microsoftSignIn.signIn();

  Future<void> resetPassword(String email) => _resetPassword.reset(email);

  User? getCurrentUser() => FirebaseAuth.instance.currentUser;
}