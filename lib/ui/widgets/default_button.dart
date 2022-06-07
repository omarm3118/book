import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class DefaultButton extends StatelessWidget {
  final String label;
  final void Function()? onPressed;
  final TextStyle? labelStyle;

  const DefaultButton(
      {Key? key, required this.label, required this.onPressed, this.labelStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          alignment: Alignment.center,
          primary: MyColors.defaultPurple,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style:labelStyle?? Theme.of(context).textTheme.labelLarge!.copyWith(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
    );
  }
}
