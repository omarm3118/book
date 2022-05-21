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
    double screenHeightMinusStatusBar =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: (screenHeightMinusStatusBar > maxHeight
                    ? maxHeight
                    : screenHeightMinusStatusBar),
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
      ),
    );
  }

  Widget loginBanner() {
    //Todo put right home banner image
    return Expanded(
      child: Container(
        width: double.infinity,
        color: MyColors.defaultBackgroundPurple,
        child: Image.asset(
          'assets/images/Illustration.png',
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
