import 'package:flutter/material.dart';
import 'components/home_components.dart';
import 'views/home_screen.dart';
import 'views/search_screen.dart';

class LayoutScreen extends StatelessWidget {
  const LayoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

//Todo direction of Navbar rtl

    double statusBar = MediaQuery.of(context).viewPadding.top;
    return Scaffold(
      body: const HomeScreen(),
      bottomNavigationBar: navigationBar(),
    );
  }


}
