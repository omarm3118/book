import 'package:book/constants/colors.dart';
import 'package:book/constants/strings.dart';
import 'package:flutter/material.dart';
import 'components/log_in_components.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: screenHeight),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              loginBanner(),
              loginBody(context),
            ],
          ),
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

  Widget loginBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: defaultPadding,
        right: defaultPadding,
        top: defaultPadding,
        bottom: defaultPadding / 2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "تسجيل الدخول",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(
            height: 9,
          ),
          emailField(),
          const SizedBox(
            height: 33,
          ),
          passwordField(),
          forgetPasswordButton(context),
          const SizedBox(
            height: 33,
          ),
          signInButton(),
          registerButton(context)
        ],
      ),
    );
  }
}
