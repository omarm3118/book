import 'package:book/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../constants/strings.dart';
import '../components/home_components.dart';
import 'search_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
//Todo direction of Navbar rtl

    double statusBar = MediaQuery.of(context).viewPadding.top;
    return Column(
      children: [
        statusBarColor(statusBar),
        Flexible(
          child: CustomScrollView(
            slivers: [
              sliverAppBar(context),
              sliverList(context),
            ],
          ),
        ),
      ],
    );
  }

  statusBarColor(statusBar) {
    return Container(
      height: statusBar,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.02, 0.5, 1],
          colors: [
            Color(0xff584F8B),
            MyColors.defaultBackgroundPurple,
            MyColors.defaultBackgroundPurple,
          ],
        ),
      ),
    );
  }

  SliverAppBar sliverAppBar(BuildContext context) {
    return SliverAppBar(
      backgroundColor: MyColors.defaultBackgroundPurple,
      snap: true,
      floating: true,
      expandedHeight: 180,
      flexibleSpace: FlexibleSpaceBar(
        background: header(context),
      ),
    );
  }

  SliverList sliverList(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          body(context),
        ],
      ),
    );
  }

  Container header(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.02, 0.4, 0.65, 1],
          colors: [
            Color(0xff584F8B),
            MyColors.defaultBackgroundPurple,
            MyColors.defaultBackgroundPurple,
            Color(0xff584F8B),
          ],
        ),
      ),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            headerWelcome(context),
            const SizedBox(
              height: 10,
            ),
            headerTitle(context),
            const SizedBox(
              height: 8,
            ),
            Flexible(child: goToCoursesButton(context)),
          ],
        ),
      ),
    );
  }

  body(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(defaultPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          bodyTitle(context),
          const SizedBox(
            height: 8,
          ),
          bookProgressCard(context),
          GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.only(top: 5),
            childAspectRatio: 4 / 3,
            shrinkWrap: true,
            crossAxisCount: 2,
            children: [
              readerProgressInfo(context,
                  label: 'عدد الكتب التي قرأتها',
                  number: '20',
                  path: 'assets/images/first.png'),
              readerProgressInfo(context,
                  label: 'عدد الصفحات التي قرأتها',
                  number: '15000',
                  path: 'assets/images/se.png'),
              readerProgressInfo(context,
                  label: 'عدد الأطروحات المكتوبة',
                  number: '80',
                  path: 'assets/images/th.png'),
              readerProgressInfo(context,
                  label: 'عدد الصفحات المنجزة اليوم',
                  number: '120',
                  path: 'assets/images/fo.png'),
            ],
          )
        ],
      ),
    );
  }
}
