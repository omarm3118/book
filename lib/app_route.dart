import 'package:book/ui/screens/log_in/log_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'constants/strings.dart';

class AppRoute {
  const AppRoute();

  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loginRoute:
        return MaterialPageRoute(
          builder: (_) => const Directionality(
              textDirection: TextDirection.rtl, child: LoginScreen()),
        );
    }
    return null;
  }
}
