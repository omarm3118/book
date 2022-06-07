import 'package:book/ui/screens/culture_courses/controller/culture_courses_cubit.dart';
import 'package:book/ui/screens/home/controller/layout_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:book/constants/colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/strings.dart';
import 'components/course_details_components.dart';

class CourseDetailsScreen extends StatelessWidget {
  CourseDetailsScreen(
      {Key? key, required this.booksId, required this.courseName})
      : super(key: key);
  final List booksId;
  final String courseName;
  late List books;

  @override
  Widget build(BuildContext context) {
    LayoutCubit layoutCubit = BlocProvider.of(context);
    CultureCoursesCubit cultureCoursesCubit = BlocProvider.of(context);
    books = layoutCubit.books
        .where((element) => booksId.contains(element.id))
        .toList();

    SystemUiOverlayStyle statusBarColor = const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    );

//Todo direction of Navbar rtl

    double statusBar = MediaQuery.of(context).viewPadding.top;
    return Scaffold(
      body: AnnotatedRegion(
        value: statusBarColor,
        child: Column(
          children: [
            statusBarContainer(statusBar),
            Flexible(
              child: CustomScrollView(
                slivers: [
                  sliverAppBar(context),
                  sliverList(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  statusBarContainer(statusBar) {
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
      leading: const BackButton(
        color: Colors.white,
      ),
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
            headerWelcome(context, courseName),
          ],
        ),
      ),
    );
  }

  body(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: defaultPadding, vertical: defaultPadding / 2),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            bodyTitle(context, courseName),
            const SizedBox(
              height: 9,
            ),
            ...List.generate(
              books.length ,
              (index) => bodyCard(
                context,
                books[index],
                index,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
