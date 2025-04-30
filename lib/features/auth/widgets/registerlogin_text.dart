import 'package:flutter/material.dart';

class RegisterLoginText extends StatelessWidget {
  final String regTextContent;
  final TextStyle? regTextStyle;
  const RegisterLoginText({super.key,required this.regTextContent,this.regTextStyle});

  @override
  Widget build(BuildContext context) {
    return Text(
      regTextContent,
      style:  regTextStyle ?? TextStyle(
        fontSize: 12.0,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.normal,
        color: Color(0xFF888888),
        fontFamily: "Inter"
      ));
  }
}

