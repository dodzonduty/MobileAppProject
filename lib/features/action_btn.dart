import 'package:flutter/material.dart';

class ActionBtn extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  final Color buttonColor;
  final Color buttonTextColor;
  final String? iconPath;
  final Icon? icon;
  final double? width;

  const ActionBtn({
    super.key,
    required this.buttonText,
    required this.onPressed,
    required this.buttonColor,
    required this.buttonTextColor,
    this.width,
    this.iconPath,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double dynamicHorizontalPadding = screenWidth * 0.1;
    double dynamicVerticalPadding = 18.0;

    return SizedBox(
      width: width ?? double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          padding: EdgeInsets.symmetric(
            vertical: dynamicVerticalPadding,
            horizontal: dynamicHorizontalPadding,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null)
              Icon(
                icon!.icon,
                color: buttonTextColor,
                size: 18,
              ),
            if (icon == null && iconPath != null)
              Image.asset(
                iconPath!,
                height: 18,
                width: 18,
              ),
            SizedBox(width: 8),
            Flexible(
              child: Text(
                buttonText,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: buttonTextColor,
                  fontSize: 16,
                  fontFamily: 'Inter',
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
     ),
);
}
}
