import 'package:book/constants/strings.dart';
import 'package:book/ui/screens/log_in/controller/login_cubit.dart';
import 'package:book/ui/widgets/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../constants/colors.dart';
import '../../../widgets/default_button.dart';
import '../../../widgets/text_form_field.dart';

DefaultTextFormField loginEmailField({
  required final TextEditingController emailController,
}) {
  return DefaultTextFormField(
    validator: (String? val) {
      if (val!.isEmpty) {
        return 'أدخل البريد الإلكتروني';
      }
      return null;
    },
    textEditingController: emailController,
    textInputAction: TextInputAction.next,
    label: 'البريد الإلكتروني',
    preIcon: const Icon(
      Icons.email_outlined,
      color: MyColors.defaultIconColor,
    ),
    keyboardType: TextInputType.emailAddress,
  );
}

BlocBuilder loginPasswordField(
  context, {
  required TextEditingController passwordController,
}) {
  LoginCubit cubit = LoginCubit.getCubit(context);
  return BlocBuilder<LoginCubit, LoginState>(
    builder: (context, state) => DefaultTextFormField(
      validator: (String? val) {
        if (val!.length < 6) {
          return 'يجب أن تكون كلمة المرور 6 رموز على الأقل';
        }
        return null;
      },
      textEditingController: passwordController,
      textInputAction: TextInputAction.done,
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
          icon: Icon(!cubit.isSecure
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
        //Todo هل نسيت كلمة المرور؟
        "",
        style: Theme.of(context).textTheme.labelLarge,
      ),
    ),
  );
}

BlocConsumer loginSignInButton(
  GlobalKey<FormState> formKey, {
  required BuildContext context,
  required TextEditingController email,
  required TextEditingController password,
}) {
  LoginCubit cubit = LoginCubit.getCubit(context);
  return BlocConsumer<LoginCubit, LoginState>(
    listener: (context, state) {
      if (state is SignInUserSuccessState) {
        Navigator.pushReplacementNamed(
          context,
          homeRoute,
        );
      }
    },
    builder: (context, state) {
      return ConditionalBuilder(
        successWidget: (context) => DefaultButton(
          label: 'تسجيل الدخول',
          onPressed: () {
            if (formKey.currentState!.validate()) {
              cubit.signInWithEmail(email: email.text, password: password.text);
            }
          },
        ),
        fallbackWidget: (context) =>
            const Center(child: CircularProgressIndicator()),
        condition: (state is! SignInUserLoadingState),
      );
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
          "أنشئ الآن",
          style: Theme.of(context)
              .textTheme
              .labelLarge!
              .copyWith(color: MyColors.defaultPurple),
        ),
      ),
    ],
  );
}
