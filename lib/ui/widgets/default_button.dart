import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class DefaultButton extends StatelessWidget {
  final String label;

  const DefaultButton({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          alignment: Alignment.center,
          primary: MyColors.defaultPurple,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {},
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge!.copyWith(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
    );
  }
}
