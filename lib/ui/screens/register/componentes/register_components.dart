import 'package:book/constants/strings.dart';
import 'package:book/ui/screens/register/controller/register_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../constants/colors.dart';
import '../../../widgets/default_button.dart';
import '../../../widgets/text_form_field.dart';

DefaultTextFormField registerLastNameField() {
  return DefaultTextFormField(
    validator: (String? val) {
      if (val!.isEmpty) {
        return 'name2 must not be empty';
      }
      return null;
    },
    label: 'الاسم الأخير',
    preIcon: const Icon(Icons.person_outlined),
  );
}

DefaultTextFormField registerNameField() {
  return DefaultTextFormField(
    validator: (String? val) {
      if (val!.isEmpty) {
        return 'name must not be empty';
      }
      return null;
    },
    label: 'الاسم الأول',
    preIcon: const Icon(Icons.person_outlined),
  );
}

DefaultTextFormField registerEmailField() {
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

BlocBuilder registerPasswordField(context) {
  RegisterCubit cubit = RegisterCubit.getCubit(context);
  return BlocBuilder<RegisterCubit, RegisterState>(
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

DefaultButton registerRegisterButton(GlobalKey<FormState> formKey, context) {
  return DefaultButton(
    label: 'إنشاء حساب',
    onPressed: () {
      if (formKey.currentState!.validate()) {
        //Todo push and pop all the previous screens
        Navigator.pushNamed(context, chooseFavoriteFieldsRoute);
      }
    },
  );
}

Row registerLoginButton(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        'لديك حساب بالفعل؟',
        style: Theme.of(context).textTheme.labelLarge,
      ),
      TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text(
          "تسجيل الدخول",
          style: Theme.of(context)
              .textTheme
              .labelLarge!
              .copyWith(color: MyColors.defaultPurple),
        ),
      ),
    ],
  );
}
