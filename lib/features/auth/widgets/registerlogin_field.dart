import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'registerlogin_text.dart';

class FormWidget extends StatefulWidget {
  final String labelText;
  final String hintText;
  final IconData? suffixData;
  final TextInputType? keyPad;

  const FormWidget({
    super.key,
    required this.labelText,
    required this.hintText,
    this.suffixData,
    this.keyPad,
  });

  @override
  State<FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  bool _obscureText = true;

  bool get _isPasswordField => widget.keyPad == TextInputType.visiblePassword;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RegisterLoginText(
          regTextContent: widget.labelText,),
        SizedBox(height: 15),
        TextFormField(
          obscureText: _isPasswordField ? _obscureText : false,
          keyboardType: widget.keyPad ?? TextInputType.text,
           inputFormatters: widget.keyPad == TextInputType.phone ? [FilteringTextInputFormatter.digitsOnly]
           : null,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(
              fontSize: 12.0,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.normal,
              color: Color(0xFFC4C4C4),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32),
              borderSide: BorderSide(
                color: Color(0xFFC4C4C4),
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32),
              borderSide: BorderSide(
                color: Color(0xFF626262),
                width: 1.0,
              ),
            ),
            suffixIcon: _isPasswordField? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Color(0xFF888888),
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    }, )
                    : null,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return widget.hintText;
            }
            return null;
          },
        ),
      ],
    );
  }
}