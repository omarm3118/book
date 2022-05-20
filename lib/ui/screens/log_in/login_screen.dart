import 'package:book/constants/colors.dart';
import 'package:book/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'components/login_components.dart';

class LoginScreen extends StatelessWidget {
   LoginScreen({Key? key}) : super(key: key);
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: MyColors.defaultBackgroundPurple,
      statusBarIconBrightness: Brightness.light,
    ));
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: (screenHeight > maxHeight ? maxHeight : screenHeight),
              maxWidth: maxWidth,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                loginBanner(),
                loginBody(context),
              ],
            ),
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
        alignment: Alignment.center,
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
        bottom: defaultPadding / 4,
      ),
      child: Form(
        key: formKey,
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
            loginEmailField(),
            const SizedBox(
              height: defaultPadding,
            ),
            loginPasswordField(context),
            loginForgetPasswordButton(context),
            const SizedBox(
              height: defaultPadding,
            ),
            loginSignInButton(formKey),
            loginRegisterButton(context)
          ],
        ),
      ),
    );
  }
}
