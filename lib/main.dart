import 'package:book/app_route.dart';
import 'package:book/constants/strings.dart';
import 'package:book/data/web_services/cache_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc_observer.dart';
import 'constants/app_themes.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  BlocOverrides.runZoned(
    () {
      runApp(const MyApp());
    },
    blocObserver: AppBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    bool? isOnBoarding = CacheHelper.getData(
      key: 'onBoarding',
    );
    print('onBoarding $isOnBoarding');
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      initialData: FirebaseAuth.instance.currentUser,
      builder: (BuildContext context, AsyncSnapshot<User?> snap) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          onGenerateRoute: AppRoute().generateRoute,
          theme: MyThemes.myLightTheme,
          initialRoute: isOnBoarding == null
              ? onBoardingRoute
              : (snap.data == null
                  ? loginRoute
                  : (snap.data != null && snap.data!.emailVerified)
                      ? homeRoute
                      : homeRoute),
        );
      },
    );
  }
}
