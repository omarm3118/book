import 'package:book/ui/screens/choose_favorite_fields/choose_favorite_fields_screen.dart';
import 'package:book/ui/screens/home/home_screen.dart';
import 'package:book/ui/screens/log_in/controller/login_cubit.dart';
import 'package:book/ui/screens/log_in/login_screen.dart';
import 'package:book/ui/screens/register/controller/register_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'constants/strings.dart';
import 'ui/screens/register/register_screen.dart';

class AppRoute {
  const AppRoute();

  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loginRoute:
        return _loginScreen();
      case registerRoute:
        return _registerScreen();
      case chooseFavoriteFieldsRoute:
        return MaterialPageRoute(
          builder: (context) => const Directionality(
            textDirection: TextDirection.rtl,
            child: ChooseFavoriteFieldsScreen(),
          ),
        );
      case homeRoute:
        return
        MaterialPageRoute(
          builder: (context) => const Directionality(
            textDirection: TextDirection.rtl,
            child: HomeScreen(),
          ),
        );

    }
    return null;
  }

  Route? _loginScreen() {
    return MaterialPageRoute(
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: BlocProvider(
            create: (BuildContext context) => LoginCubit(),
            //Todo Login
            child: ChooseFavoriteFieldsScreen() //LoginScreen(),
            ),
      ),
    );
  }

  Route? _registerScreen() {
    return MaterialPageRoute(
      builder: (_) => BlocProvider(
        create: (context) => RegisterCubit(),
        child: Directionality(
            textDirection: TextDirection.rtl, child: RegisterScreen()),
      ),
    );
  }
}
