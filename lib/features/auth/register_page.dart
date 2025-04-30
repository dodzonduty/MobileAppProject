import 'package:flutter/material.dart';
import 'login_page.dart';
import 'widgets/registerlogin_btn.dart';
import 'widgets/registerlogin_field.dart';
import 'widgets/registerlogin_text.dart';
import 'widgets/registerlogin_txtbtn.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight +80),
        child: Padding(
            padding: EdgeInsets.only(top: 50),
            child: AppBar(
              backgroundColor: Colors.white,
              leading: IconButton(
                icon: Icon(Icons.chevron_left),
                iconSize: 30,
                onPressed: () => Navigator.pop(context),
                ),
              title: RegisterLoginText(regTextContent: "Register",
              regTextStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Colors.black)),
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
                  RegisterLoginText(regTextContent: 'Hello!',regTextStyle:TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Colors.black)),
                  SizedBox(height: 17,),
                  RegisterLoginText(regTextContent: 'Create a new account', regTextStyle:TextStyle(
                    fontSize: 14, color: Color(0xFF888888))),
                  SizedBox(height: 32,),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Flexible(child: FormWidget(labelText: "First Name", hintText: 'Enter your first name'),),
                            SizedBox(width: 9,),
                            Flexible(child: FormWidget(labelText: "Last Name", hintText: 'Enter your last name'))
                          ],),
                        SizedBox(height: 22,),
                        FormWidget(labelText: "E-mail Address", hintText: 'Enter your e-mail', keyPad: TextInputType.emailAddress,),
                        SizedBox(height: 22,),
                        FormWidget(labelText: "Phone Number", hintText: 'Enter your phone number', keyPad: TextInputType.phone,),
                        SizedBox(height: 22,),
                        FormWidget(labelText: "Password", hintText: 'Enter your password', keyPad: TextInputType.visiblePassword,),
                        SizedBox(height: 40,),
                        RegLogBtn(buttonText: "Register", onPressed: () {if (_formKey.currentState!.validate()) {}}, buttonColor: Color(0xFF445B70),
                        buttonTextColor:Colors.white),
                        //onPressed >> must naviagte to main
                        SizedBox(height: 16,),
                        RegisterloginTxtbtn(actionText: "Already have an account?", textButtonColor: Color(0xFF445B70),
                        buttonText: "Login", onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                              builder: (context) => LoginPage(), )); } )
                      ],
                    ),
                  )
                  ],
                ),
            )
        ),
        ),
    );
  }
}