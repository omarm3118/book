import 'package:book/constants/colors.dart';
import 'package:book/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'components/login_components.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
      backgroundColor: MyColors.defaultBackgroundPurple,
      body: AnnotatedRegion(
        value: statusBarColor,
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: loginBanner()),
                  loginBody(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget loginBanner() {
    //Todo put right home banner image svg file
    return Container(
      width: double.infinity,
      color: MyColors.defaultBackgroundPurple,
      child: Image.asset(
        'assets/images/book.png',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget loginBody(BuildContext context) {
    return Container(

      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(defaultRadius))
      ),
      child: Padding(
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
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "تسجيل الدخول",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(
                height: 9,
              ),
              loginEmailField(
                emailController: emailController,
              ),
              const SizedBox(
                height: defaultPadding,
              ),
              loginPasswordField(
                context,
                passwordController: passwordController,
              ),
              loginForgetPasswordButton(context),
              const SizedBox(
                height: defaultPadding,
              ),
              loginSignInButton(
                formKey,
                email: emailController,
                password: passwordController,
                context: context,
              ),
              loginRegisterButton(context)
            ],
          ),
        ),
      ),
    );
  }
}
