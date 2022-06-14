import 'package:book/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<bool?> showingToast({
  required String msg,
  required ToastState state,
  bool isGravityTop=false,
}) async {
  Color toastColor;

  switch (state) {
    case ToastState.success:
      toastColor = Colors.teal;
      break;
    case ToastState.error:
      toastColor = Colors.red;
      break;
    case ToastState.warning:
      toastColor = Colors.amber;
      break;
    case ToastState.checked:
      toastColor = MyColors.defaultPurple.withOpacity(0.7);
      break;
    default:
      toastColor = Colors.black87;
  }

  return await Fluttertoast.showToast(
    msg: msg,
    textColor: Colors.white,
    gravity: isGravityTop?ToastGravity.TOP:ToastGravity.BOTTOM,
    toastLength: Toast.LENGTH_LONG,
    backgroundColor: toastColor,
  );
}

enum ToastState { success, error, warning, checked }
