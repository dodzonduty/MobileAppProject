// File: login_page.dart
import 'package:flutter/material.dart';
import 'register_page.dart';
import 'widgets/registerlogin_btn.dart';
import 'widgets/registerlogin_field.dart';
import 'widgets/registerlogin_text.dart';
import 'widgets/registerlogin_txtbtn.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight +100),
        child: Padding(
            padding: EdgeInsets.only(top: 80),
            child: AppBar(
              backgroundColor: Colors.white,
              leading: IconButton(
                icon: Icon(Icons.chevron_left), iconSize: 30,
                onPressed: () => Navigator.pop(context),
                ),
              title: RegisterLoginText(regTextContent: "Login",
              regTextStyle: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w800, color: Colors.black)),
                titleSpacing: 0,
            ),
          ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RegisterLoginText(regTextContent: 'Welcome',regTextStyle:TextStyle(
                    fontSize: 24, fontWeight: FontWeight.w800, color: Colors.black)),
                  SizedBox(height: 17,),
                  RegisterLoginText(regTextContent: 'Sign In to your account', regTextStyle:TextStyle(
                    fontSize: 14, color: Color(0xFF888888))),
                  SizedBox(height: 32,),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        FormWidget(labelText: "E-mail Address", hintText: 'Enter your e-mail', keyPad: TextInputType.emailAddress,),
                        SizedBox(height: 22,),
                        FormWidget(labelText: "Password", hintText: 'Enter your password', keyPad: TextInputType.visiblePassword,),
                        SizedBox(height: 3,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [RegisterloginTxtbtn(actionText: null, textButtonColor: Color(0xFF834746),
                          onPressed: () {}, buttonText: 'Forgot Password?',)
                        //onPressed >> navigate to forgot passowrd page] ,
                      ]),
                      SizedBox(height: 16,),
                      RegLogBtn(buttonText: "Login", onPressed: () {if (_formKey.currentState!.validate()) {} }, buttonColor: Color(0xFF445B70),
                        buttonTextColor:Colors.white),
                      SizedBox(height: 16,),
                      RegisterloginTxtbtn(actionText: "Don’t have an account?", textButtonColor: Color(0xFF834746),
                      buttonText: "Sign Up", onPressed: () {
                        Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterPage()),); } ),
                        SizedBox(height: 16,),
                         Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Container(
                                height: 1.0, color: Color(0xFFF2F2F2),
                                margin: EdgeInsets.only(right: 8.0),
                              ),
                            ),
                           RegisterLoginText(regTextContent: "Or Sign In With"),
                            Expanded(
                              child: Container(
                                height: 1.0, color: Color(0xFFF2F2F2),
                                margin: EdgeInsets.only(left: 8.0),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 22,),
                        RegLogBtn(buttonText: "Outlook", onPressed: (){}, iconPath: 'assets/images/Outlook_Logo.png',
                        buttonColor: Color(0xFFF3F3F3), buttonTextColor: Color(0xFF4B4B4B)),
                      ]
                    )
                  )
                ]
                )
      )
        )
      )
    );
  }
}
