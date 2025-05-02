import 'package:flutter/material.dart';
import 'package:project/features/auth/widgets/registerlogin_text.dart';
import 'package:project/features/auth/widgets/registerlogin_txtbtn.dart';
import 'login_page.dart';  // Import Login Page
import 'register_page.dart';
import 'widgets/registerlogin_btn.dart'; // Import Register Page

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Background.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.4),
              BlendMode.darken,
            ),
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo and Title
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/Group.png',
                      width: screenWidth * 0.5,
                      height: screenWidth * 0.5,
                    ),
                    SizedBox(height: 16),
                    RegisterLoginText(regTextContent: "Campus Companion",
                    regTextStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      )
                    ),
                    RegisterLoginText(regTextContent: "Faculty of Engineering - Shoubra",
                    regTextStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      )
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.2),
                RegLogBtn(
                  buttonText: "Login",
                  onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginPage(),
                                  ),
                                );
                              },
                  buttonColor: Color(0xFF445B70),
                  buttonTextColor: Colors.white,
                  ),
                SizedBox(height: 16),
                RegisterloginTxtbtn(
                  textButtonColor: Colors.white,
                  buttonText: "Create New Account",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterPage(),
                        ),
                        );
                        },
                        ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}