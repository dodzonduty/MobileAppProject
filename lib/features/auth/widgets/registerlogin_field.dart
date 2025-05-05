import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'registerlogin_text.dart';

class FormWidget extends StatefulWidget {
  final String labelText;
  final String hintText;
  final IconData? suffixData;
  final TextInputType? keyPad;
  final TextEditingController? controller; // Add controller
  final String? Function(String?)? validator; // Add custom validator
  final Widget? prefixWidget;

  const FormWidget({
    super.key,
    required this.labelText,
    required this.hintText,
    this.suffixData,
    this.keyPad,
    this.controller,
    this.validator, this.prefixWidget,
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
        RegisterLoginText(regTextContent: widget.labelText),
        const SizedBox(height: 15),
        TextFormField(
          controller: widget.controller, // Use provided controller
          obscureText: _isPasswordField ? _obscureText : false,
          keyboardType: widget.keyPad ?? TextInputType.text,
          inputFormatters: widget.keyPad == TextInputType.phone
          ? [FilteringTextInputFormatter.allow(RegExp(r'[\d+\-]'))]
          : null,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: const TextStyle(
              fontSize: 12.0,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.normal,
              color: Color(0xFFC4C4C4),   
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32),
              borderSide: const BorderSide(
                color: Color(0xFFC4C4C4),
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32),
              borderSide: const BorderSide(
                color: Color(0xFF626262),
                width: 1.0,
              ),
            ),
           prefixIcon: widget.prefixWidget != null
           ? Padding(
            padding: const EdgeInsets.only(left: 12, right: 4),
            child: widget.prefixWidget,
            )
             : null,
            suffixIcon: _isPasswordField
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: const Color(0xFF888888),
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : (widget.suffixData != null
                    ? Icon(widget.suffixData, color: const Color(0xFF888888))
                    : null),
          ),
          validator: widget.validator ?? (value) {
            // Default validator if none provided
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