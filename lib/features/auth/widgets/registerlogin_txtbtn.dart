import 'package:flutter/material.dart';
import 'registerlogin_text.dart';

class RegisterloginTxtbtn extends StatelessWidget {
  final String? actionText;
  final String buttonText;
  final Color textButtonColor;
  final VoidCallback onPressed;
  const RegisterloginTxtbtn({super.key, this.actionText, required this.textButtonColor,
  required this.onPressed, required this.buttonText,});

  @override
  Widget build(BuildContext context) {
    return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RegisterLoginText(
              regTextContent: actionText ?? "",),
            if (actionText != null)
            SizedBox(width: 5), //for some reason it doesn't do anything :(
            TextButton(onPressed: onPressed,
            child: RegisterLoginText(regTextContent: buttonText,
            regTextStyle: TextStyle(fontWeight: FontWeight.w800, color: textButtonColor)
            )
            )
          ],
    );
  }
}