import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  const AuthTextField({
    super.key,
    required this.hintText,
    required this.height,
    required this.borderRadius,
    required this.fontSize,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
  });

  final String hintText;
  final double height;
  final double borderRadius;
  final double fontSize;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  static const Color fillColor = Color(0xFFF1F1F1);
  static const Color textColor = Color(0xFF202020);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: TextField(
        obscureText: obscureText,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(
          color: textColor,
          fontSize: fontSize,
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: textColor.withValues(alpha: 0.88),
            fontSize: fontSize,
            fontWeight: FontWeight.w400,
          ),
          filled: true,
          fillColor: fillColor,
          contentPadding: EdgeInsets.symmetric(
            horizontal: height * 0.38,
            vertical: 0,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}