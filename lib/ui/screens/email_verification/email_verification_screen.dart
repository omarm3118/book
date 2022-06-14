import 'dart:async';

import 'package:book/constants/strings.dart';
import 'package:book/ui/widgets/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EmailVerificationScreen extends StatefulWidget {
  EmailVerificationScreen({Key? key}) : super(key: key);

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
  Timer? timer;
  bool canResendEmail = true;
  SystemUiOverlayStyle statusBarColor = const SystemUiOverlayStyle(
    statusBarColor: Colors.white,
    statusBarIconBrightness: Brightness.dark,
  );

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      if (isEmailVerified) {
        Navigator.pushReplacementNamed(
          context,
          homeRoute,
        );
      }
    });
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: statusBarColor,
        title: Text(''),
      ),
      body: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              FirebaseAuth.instance.currentUser!.email.toString(),
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 24,
            ),
            Text(
              'تم إرسال بريد إلكتروني للتحقق إلى بريدك الإلكتروني ',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 24,
            ),
            ElevatedButton.icon(
              onPressed: canResendEmail
                  ? () {
                      sendVerificationEmail();
                    }
                  : null,
              icon: Icon(Icons.email_outlined),
              label: Text(
                'إعادة الإرسال',
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  sendVerificationEmail() async {
    try {
      await FirebaseAuth.instance.currentUser!.sendEmailVerification();
      setState(() {
        canResendEmail = false;
      });
      await Future.delayed(
        Duration(seconds: 10),
      );
      setState(() {
        canResendEmail = true;
      });
      timer =
          Timer.periodic(Duration(seconds: 5), (timer) => checkEmailVerified());
    } catch (e) {
      showingToast(msg: e.toString(), state: ToastState.error);
    }
  }

  checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();

    if (FirebaseAuth.instance.currentUser!.emailVerified) {
      setState(() {
        isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
      });
      timer?.cancel();
    }
  }
}
