import 'package:book/app_route.dart';
import 'package:book/constants/colors.dart';
import 'package:book/ui/screens/log_in/controller/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'bloc_observer.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      onGenerateRoute: const AppRoute().generateRoute,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: MyColors.defaultPurple,
        primarySwatch: Colors.purple,
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: MyColors.defaultBackgroundPurple,
            statusBarIconBrightness: Brightness.light,
          ),
        ),

        // SemiBold 600 // Normal(Regular) 400 // Light 300
        textTheme: const TextTheme(
          headlineSmall: TextStyle(
            fontWeight: FontWeight.bold,
          ),
          labelLarge: TextStyle(
            color: Color(0xff808080),
          ),
          titleMedium: TextStyle(
            fontWeight: FontWeight.w600,
          ),
          titleSmall: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),

        navigationBarTheme: NavigationBarThemeData(
          indicatorColor: Colors.indigo.withOpacity(0.5),
          height: 50,
          backgroundColor: Colors.white,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide

        ),
      ),
    );
  }
}
