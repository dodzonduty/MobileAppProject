import 'package:flutter/material.dart';
import 'package:project/features/profile/Profile.dart';
import 'widgets/registerlogin_btn.dart';
import 'widgets/registerlogin_field.dart';
import 'widgets/registerlogin_text.dart';
import 'widgets/registerlogin_txtbtn.dart';
import 'package:project/features/Services/auth/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  Future<void> _handleEmailSignUp() async {
    if (_formKey.currentState!.validate()) {
      try {
        final userCredential = await _authService.signUpWithEmail(
          email: _emailController.text,
          password: _passwordController.text,
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          phoneNumber: _phoneNumberController.text,
        );
        if (userCredential != null) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed: $e')),
        );
      }
    }
  }

  Future<void> _handleMicrosoftSignIn() async {
    try {
      final userCredential = await _authService.signInWithMicrosoft();
      if (userCredential != null) {
        print('Navigating to home page after Microsoft login');
          Navigator.pop(context);
        
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      print('Caught Microsoft login error in RegisterPage: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Microsoft registration failed: $e')),
      );
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
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
                padding: EdgeInsets.only(top: 10, left: 3, right: 20),
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
                          regTextContent: "Register",
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
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height -MediaQuery.of(context).padding.top -kToolbarHeight,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RegisterLoginText(
                        regTextContent: 'Create Account',
                        regTextStyle: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 17),
                      RegisterLoginText(
                        regTextContent: 'Sign Up to get started',
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
                            Row(
                              children: [
                                Flexible(
                                  child: FormWidget(
                                    labelText: "First Name",
                                    hintText: 'Enter your first name',
                                    keyPad: TextInputType.name,
                                    controller: _firstNameController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your first name';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                SizedBox(width: 9),
                                Flexible(
                                  child: FormWidget(
                                    labelText: "Last Name",
                                    hintText: 'Enter your last name',
                                    keyPad: TextInputType.name,
                                    controller: _lastNameController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your last name';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 22),
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
                              labelText: "Phone Number",
                              hintText: 'Enter your phone number',
                              keyPad: TextInputType.phone,
                              controller: _phoneNumberController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your phone number';
                                }
                                if (!RegExp(r'^(\+20|0)?1[0-2,5]\d{8}$').hasMatch(value)) {
                                  return 'Please enter a valid phone number';
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
                            SizedBox(height: 16),
                            RegLogBtn(
                              buttonText: "Sign Up",
                              onPressed: _handleEmailSignUp,
                              buttonColor: Color(0xFF445B70),
                              buttonTextColor: Colors.white,
                            ),
                            SizedBox(height: 16),
                            RegisterloginTxtbtn(
                              actionText: "Already have an account?",
                              textButtonColor: Color(0xFF445B70),
                              buttonText: " Login ",
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: //(context) => ProfilePage()
                                    (context) => ProfilePage(), //this line navigates just to view the profile page, it's definitely wrong
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
                                RegisterLoginText(regTextContent: "Or Sign Up With"),
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
          ],
        ),
      ),
    );
  }
}