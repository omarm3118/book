import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

 Future<bool?> showingToast({
  required String msg,
  required ToastState state,
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
    default:
      toastColor = Colors.black87;
  }

  return await Fluttertoast.showToast(
    msg: msg,
    textColor: Colors.white,
    gravity: ToastGravity.BOTTOM,
    toastLength: Toast.LENGTH_LONG,
    backgroundColor: toastColor,
  );
}

enum ToastState { success, error, warning }