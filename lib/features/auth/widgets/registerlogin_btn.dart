import 'package:flutter/material.dart';

class RegLogBtn extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  final Color buttonColor;
  final Color buttonTextColor;
  final String? iconPath;
  final double? width;
  const RegLogBtn({super.key, required this.buttonText, required this.onPressed, 
  required this.buttonColor, required this.buttonTextColor, this.width, this.iconPath});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          padding: EdgeInsets.symmetric(vertical: 18, horizontal: 130),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (iconPath != null)
              Image.asset(
                iconPath!,
                height: 18,
                width: 18,
              ),
            if (iconPath != null) SizedBox(width: 8),
            Text(
              buttonText,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: buttonTextColor,
                fontSize: 16,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ),
    );
  }
}