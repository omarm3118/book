import 'package:flutter/material.dart';

class DefaultTextFormField extends StatelessWidget {
  final String label;
  final Widget? preIcon;
  final Widget? suffixIcon;
  final bool isPassword;
  final TextInputType? keyboardType;
  final TextEditingController? textEditingController;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;

  const DefaultTextFormField({
    Key? key,
    required this.label,
    required this.preIcon,
    this.suffixIcon,
    this.isPassword = false,
    this.keyboardType,
    this.textEditingController,
    this.validator,
    this.textInputAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      textInputAction: textInputAction,
      obscureText: isPassword,
      keyboardType: keyboardType,
      controller: textEditingController,
      decoration: InputDecoration(
        labelText: label,
        //contentPadding: const EdgeInsets.all(20),
        prefixIcon: preIcon,
        suffixIcon: suffixIcon,
        // border: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(defaultRadius),
        // ),
      ),
    );
  }
}
