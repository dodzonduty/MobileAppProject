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
        // Display the actionText if not null
        if (actionText != null)
          RegisterLoginText(regTextContent: actionText ?? ""),
        if (actionText != null) 
          SizedBox(width: 8),
        TextButton(
          onPressed: onPressed,
          child: RegisterLoginText(
            regTextContent: buttonText,
            regTextStyle: TextStyle(
              fontWeight: FontWeight.w800, 
              color: textButtonColor,
            ),
          ),
        ),
      ],
    );
  }
}