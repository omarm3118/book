import 'package:book/constants/colors.dart';
import 'package:book/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'components/register_components.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //Todo with or without safeArea

    SystemUiOverlayStyle statusBarColor = const SystemUiOverlayStyle(
      statusBarColor: MyColors.defaultBackgroundPurple,
      statusBarIconBrightness: Brightness.light,
    );
    // double screenHeightMinusStatusBar =
    //     MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    return Scaffold(
      body: AnnotatedRegion(
        value: statusBarColor,
        child: CustomScrollView(
          slivers: [
            SliverSafeArea(
              sliver: SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    loginBanner(),
                    loginBody(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget loginBanner() {
    return Expanded(
      child: Container(
        width: double.infinity,
        color: MyColors.defaultBackgroundPurple,
        child: Image.asset(
          'assets/images/book.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  loginBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: defaultPadding,
        right: defaultPadding,
        top: defaultPadding / 2,
        bottom: defaultPadding / 4,
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "إنشاء حساب",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(
              height: 8,
            ),
            registerNameField(nameController),
            const SizedBox(
              height: 8,
            ),
            registerLastNameField(lastNameController),
            const SizedBox(
              height: 8,
            ),
            registerEmailField(emailController),
            const SizedBox(
              height: 8,
            ),
            registerPasswordField(context, passwordController),
            const SizedBox(
              height: defaultPadding / 2,
            ),
            registerRegisterButton(
              formKey,
              context,
              email: emailController,
              password: passwordController,
              name: nameController,
              lastName: lastNameController,
            ),
            registerLoginButton(context),
          ],
        ),
      ),
    );
  }
}
