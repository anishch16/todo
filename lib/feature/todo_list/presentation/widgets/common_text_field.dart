import 'package:flutter/material.dart';

class CommonTextField extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int maxLines;
  final int minLines;
  final BorderType borderType;
  final String? Function(String?)? validator;
  final bool showCounter;
  final int? maxLength;

  const CommonTextField({
    super.key,
    this.hintText,
    this.labelText,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.minLines = 1,
    this.borderType = BorderType.outline,
    this.validator,
    this.showCounter = false,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: maxLines,
      minLines: minLines,
      validator: validator,
      maxLength: maxLength,

      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        alignLabelWithHint: false,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        counter: showCounter ? null : SizedBox.shrink(),
        hintStyle: const TextStyle(color: Colors.grey),
        enabledBorder: _getBorder(),
        focusedBorder: _getBorder(color: Theme.of(context).primaryColor),
        errorBorder: _getBorder(color: Colors.red),
        focusedErrorBorder: _getBorder(color: Colors.red),
      ),
    );
  }

  InputBorder _getBorder({Color? color}) {
    switch (borderType) {
      case BorderType.outline:
        return OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: color ?? Colors.grey),
        );

      case BorderType.underline:
        return UnderlineInputBorder(
          borderSide: BorderSide(color: color ?? Colors.grey),
        );

      case BorderType.none:
        return InputBorder.none;
    }
  }
}

enum BorderType { outline, underline, none }
