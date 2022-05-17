import 'package:book/app_route.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
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
        textTheme: const TextTheme(
          headlineSmall: TextStyle(
            fontWeight: FontWeight.bold,
          ),
          labelLarge: TextStyle(
            color: Color(0xff808080),
          ),
        ),
      ),
    );
  }
}
