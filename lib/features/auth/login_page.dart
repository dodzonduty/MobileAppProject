import 'package:flutter/material.dart';
import 'package:project/features/auth/register_page.dart';
import 'widgets/registerlogin_btn.dart';
import 'widgets/registerlogin_field.dart';
import 'widgets/registerlogin_text.dart';
import 'widgets/registerlogin_txtbtn.dart';
import 'package:project/features/Services/auth/auth_service.dart';
import 'package:project/features/auth/login_page.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  Future<void> _handleEmailSignIn() async {
    if (_formKey.currentState!.validate()) {
      try {
        final userCredential = await _authService.signInWithEmail(
          _emailController.text,
          _passwordController.text,
        );
        if (userCredential != null) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: $e')),
        );
      }
    }
  }

  Future<void> _handleMicrosoftSignIn() async {
    try {
      final userCredential = await _authService.signInWithMicrosoft();
      if (userCredential != null) {
        print('Navigating to home page after Microsoft login');
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      print('Caught Microsoft login error in LoginPage: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Microsoft login failed: $e')),
      );
    }
  }

  Future<void> _handlePasswordReset() async {
    if (_emailController.text.isNotEmpty) {
      try {
        await _authService.resetPassword(_emailController.text);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password reset email sent')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter your email')),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: false,
              floating: true,
              snap: true,
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              expandedHeight: 80,
              flexibleSpace: Padding(
                padding: EdgeInsets.only(top: 10, left: 3, right: 20,),
                child: SafeArea(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          icon: Icon(Icons.chevron_left, size: 30),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: RegisterLoginText(
                          regTextContent: "Login",
                          regTextStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.05,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 15),
                        RegisterLoginText(
                          regTextContent: 'Welcome',
                          regTextStyle: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 17),
                        RegisterLoginText(
                          regTextContent: 'Sign In to your account',
                          regTextStyle: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF888888),
                          ),
                        ),
                        SizedBox(height: 32),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              FormWidget(
                                labelText: "E-mail Address",
                                hintText: 'Enter your e-mail',
                                keyPad: TextInputType.emailAddress,
                                controller: _emailController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                                    return 'Please enter a valid email';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 22),
                              FormWidget(
                                labelText: "Password",
                                hintText: 'Enter your password',
                                keyPad: TextInputType.visiblePassword,
                                controller: _passwordController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  if (value.length < 6) {
                                    return 'Password must be at least 6 characters';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 3),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  RegisterloginTxtbtn(
                                    actionText: null,
                                    textButtonColor: Color(0xFF834746),
                                    onPressed: _handlePasswordReset,
                                    buttonText: 'Forgot Password?',
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                              RegLogBtn(
                                buttonText: "Login",
                                onPressed: _handleEmailSignIn,
                                buttonColor: Color(0xFF445B70),
                                buttonTextColor: Colors.white,
                              ),
                              SizedBox(height: 16),
                              RegisterloginTxtbtn(
                                actionText: "Don't have an account?",
                                textButtonColor: Color(0xFF834746),
                                buttonText: "Sign Up",
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RegisterPage(),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 1.0,
                                      color: Color(0xFFF2F2F2),
                                      margin: EdgeInsets.only(right: 8.0),
                                    ),
                                  ),
                                  RegisterLoginText(regTextContent: "Or Sign In With"),
                                  Expanded(
                                    child: Container(
                                      height: 1.0,
                                      color: Color(0xFFF2F2F2),
                                      margin: EdgeInsets.only(left: 8.0),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 22),
                              RegLogBtn(
                                buttonText: "Outlook",
                                onPressed: _handleMicrosoftSignIn,
                                iconPath: 'assets/images/Outlook_Logo.png',
                                buttonColor: Color(0xFFF3F3F3),
                                buttonTextColor: Color(0xFF4B4B4B),
                              ),
                              SizedBox(height: 24),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
