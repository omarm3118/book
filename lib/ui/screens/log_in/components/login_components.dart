import 'package:book/constants/strings.dart';
import 'package:book/ui/screens/log_in/controller/login_cubit.dart';
import 'package:book/ui/screens/register/controller/register_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../constants/colors.dart';
import '../../../widgets/default_button.dart';
import '../../../widgets/text_form_field.dart';

DefaultTextFormField loginEmailField() {
  return DefaultTextFormField(
    validator: (String? val) {
      if (val!.isEmpty) {
        return 'email must not be empty';
      }
      return null;
    },
    label: 'اسم المستخدم',
    preIcon: const Icon(
      Icons.email_outlined,
      color: MyColors.defaultIconColor,
    ),
    keyboardType: TextInputType.emailAddress,
  );
}

BlocBuilder loginPasswordField(context) {
  LoginCubit cubit =LoginCubit.getCubit(context);
  return BlocBuilder<LoginCubit, LoginState>(
    builder: (context, state) => DefaultTextFormField(
      validator: (String? val) {
        if (val!.length < 6) {
          return 'password must be more than 6 characters';
        }
        return null;
      },
      label: 'كلمة المرور',
      preIcon: const Icon(
        Icons.lock_outline,
        color: MyColors.defaultIconColor,
      ),
      suffixIcon: IconButton(
          color: MyColors.defaultIconColor,
          onPressed: () {
            cubit.changePasswordVisibility();
          },
          icon: Icon(cubit.isSecure
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined)),
      isPassword: cubit.isSecure,
      keyboardType: TextInputType.visiblePassword,
    ),
  );
}

Container loginForgetPasswordButton(BuildContext context) {
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

DefaultButton loginSignInButton(GlobalKey<FormState> formKey) {
  return DefaultButton(
    label: 'تسجيل الدخول',
    onPressed: () {
      formKey.currentState!.validate();
    },
  );
}

Row loginRegisterButton(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        'ليس لديك حساب؟',
        style: Theme.of(context).textTheme.labelLarge,
      ),
      TextButton(
        onPressed: () {
          Navigator.pushNamed(context, registerRoute);
        },
        child: Text(
          "سجّل الآن",
          style: Theme.of(context)
              .textTheme
              .labelLarge!
              .copyWith(color: MyColors.defaultPurple),
        ),
      ),
    ],
  );
}
