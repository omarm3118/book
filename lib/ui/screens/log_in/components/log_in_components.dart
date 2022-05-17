import 'package:flutter/material.dart';

import '../../../../constants/colors.dart';
import '../../../widgets/default_button.dart';
import '../../../widgets/text_form_field.dart';

DefaultTextFormField emailField() {
  return const DefaultTextFormField(
    label: 'اسم المستخدم',
    preIcon: Icon(
      Icons.email_outlined,
      color: MyColors.defaultIconColor,
    ),
  );
}

DefaultTextFormField passwordField() {
  return const DefaultTextFormField(
    label: 'كلمة المرور',
    preIcon: Icon(
      Icons.lock_outline,
      color: MyColors.defaultIconColor,
    ),
    suffixIcon: Icon(
      Icons.remove_red_eye_outlined,
      color: MyColors.defaultIconColor,
    ),
    isPassword: true,
  );
}

Container forgetPasswordButton(BuildContext context) {
  return Container(
    width: double.infinity,
    alignment: AlignmentDirectional.topEnd,
    //color: Colors.red,
    child: TextButton(
      style: TextButton.styleFrom(
        alignment: AlignmentDirectional.topEnd,
        padding: EdgeInsets.zero,
        minimumSize: const Size(1, 1),
      ),
      onPressed: () {},
      child: Text(
        "هل نسيت كلمة المرور؟",
        style: Theme.of(context).textTheme.labelLarge,
      ),
    ),
  );
}

DefaultButton signInButton() => const DefaultButton(label: 'تسجيل الدخول');

Row registerButton(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        'ليس لديك حساب؟',
        style: Theme.of(context).textTheme.labelLarge,
      ),
      TextButton(
        onPressed: () {},
        child: Text(
          "سجل الآن",
          style: Theme.of(context)
              .textTheme
              .labelLarge!
              .copyWith(color: MyColors.defaultPurple),
        ),
      ),
    ],
  );
}
