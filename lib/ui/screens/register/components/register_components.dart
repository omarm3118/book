import 'package:book/constants/strings.dart';
import 'package:book/ui/screens/register/controller/register_cubit.dart';
import 'package:book/ui/widgets/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../constants/colors.dart';
import '../../../widgets/default_button.dart';
import '../../../widgets/text_form_field.dart';

DefaultTextFormField registerLastNameField(
    TextEditingController lastNameController) {
  return DefaultTextFormField(
    validator: (String? val) {
      if (val!.isEmpty) {
        return 'name2 must not be empty';
      }
      return null;
    },
    textEditingController: lastNameController,
    textInputAction: TextInputAction.next,
    label: 'الاسم الأخير',
    preIcon: const Icon(Icons.person_outlined),
  );
}

DefaultTextFormField registerNameField(TextEditingController nameController) {
  return DefaultTextFormField(
    validator: (String? val) {
      if (val!.isEmpty) {
        return 'name must not be empty';
      }
      return null;
    },
    textEditingController: nameController,
    textInputAction: TextInputAction.next,
    label: 'الاسم الأول',
    preIcon: const Icon(Icons.person_outlined),
  );
}

DefaultTextFormField registerEmailField(TextEditingController emailController) {
  return DefaultTextFormField(
    textEditingController: emailController,
    validator: (String? val) {
      if (val!.isEmpty) {
        return 'email must not be empty';
      }
      return null;
    },
    textInputAction: TextInputAction.next,
    label: 'اسم المستخدم',
    preIcon: const Icon(
      Icons.email_outlined,
      color: MyColors.defaultIconColor,
    ),
    keyboardType: TextInputType.emailAddress,
  );
}

BlocBuilder registerPasswordField(
    context, TextEditingController passwordController) {
  RegisterCubit cubit = RegisterCubit.getCubit(context);
  return BlocBuilder<RegisterCubit, RegisterState>(
    builder: (context, state) => DefaultTextFormField(
      textEditingController: passwordController,
      validator: (String? val) {
        if (val!.length < 6) {
          return 'password must be more than 6 characters';
        }
        return null;
      },
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

registerRegisterButton(GlobalKey<FormState> formKey, context,
    {required TextEditingController email,
    required TextEditingController password,
    required TextEditingController name,
    required TextEditingController lastName}) {
  RegisterCubit cubit = RegisterCubit.getCubit(context);

  return BlocConsumer<RegisterCubit, RegisterState>(
    listener: (context, state) {
      if (state is AddUserToFirestoreSuccessState) {
        Navigator.pop(context);
      }
    },
    builder: (context, state) {
      return ConditionalBuilder(
        successWidget:(context)=> DefaultButton(
          label: 'إنشاء حساب',
          onPressed: () {
            if (formKey.currentState!.validate()) {
              //Todo push and pop all the previous screens
              cubit.registerWithEmail(
                email: email.text,
                password: password.text,
                name: name.text,
                lastName: lastName.text,
              );
            }
          },
        ),
        fallbackWidget: (context)=>const Center(child: CircularProgressIndicator()),
        condition: state is! RegisterUserLoadingState &&
            state is! AddUserToFirestoreLoadingState,
      );
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
