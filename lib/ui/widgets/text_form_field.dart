import 'package:flutter/material.dart';

import '../../constants/strings.dart';

class DefaultTextFormField extends StatelessWidget {
  final String label;
  final Widget preIcon;
  final Widget? suffixIcon;
  final bool isPassword;

  const DefaultTextFormField({
    Key? key,
    required this.label,
    required this.preIcon,
    this.suffixIcon,
    this.isPassword = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: preIcon,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(defaultRadius),
        ),
      ),
    );
  }
}
