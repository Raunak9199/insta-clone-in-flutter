import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.fieldHeight,
    required this.fieldWidth,
    this.prefixIconWidget,
    this.prefixIconHeight,
    this.prefixIconWidth,
    required this.borderRadius,
    required this.borderColor,
    this.onsaved,
    required this.textStyle,
    required this.hintStyle,
    this.suffixIconImage,
    this.suffixIconHeight,
    this.suffixIconWidth,
    required this.isMultilineText,
    this.numberOfLine,
  });

  final TextEditingController controller;
  final String hintText;
  final double fieldHeight;
  final double fieldWidth;
  final Widget? prefixIconWidget;
  final double? prefixIconHeight;
  final double? prefixIconWidth;
  final Widget? suffixIconImage;
  final double? suffixIconHeight;
  final double? suffixIconWidth;
  final double borderRadius;
  final Color borderColor;
  final TextStyle textStyle;
  final TextStyle hintStyle;
  final bool isMultilineText;
  final int? numberOfLine;
  final void Function(String?)? onsaved;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: fieldWidth,
      height: fieldHeight,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(38.r),
      ),
      child: TextField(
        cursorHeight: 18,
        autofocus: false,
        style: textStyle,
        controller: controller,
        maxLines: isMultilineText ? numberOfLine : 1,
        decoration: InputDecoration(
          prefixIconConstraints:
              BoxConstraints(maxHeight: 24.w, maxWidth: 24.w),
          hintText: hintText,
          hintStyle: hintStyle,
          prefixIcon: prefixIconWidget,
          suffixIcon: suffixIconImage,
          contentPadding:
              EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(color: borderColor, width: 1.r),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(color: borderColor, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(color: borderColor, width: 1.5),
          ),
        ),
      ),
    );
  }
}
