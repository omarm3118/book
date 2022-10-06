import 'package:book/constants/colors.dart';
import 'package:book/data/models/book_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../constants/strings.dart';
import '../../../../data/models/user_model.dart';
import '../../../widgets/conditional_builder.dart';
import '../components/dashboard_components.dart';
import '../controller/layout_cubit.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemUiOverlayStyle statusBarColor = const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    );

//Todo direction of Navbar rtl

    double statusBar = MediaQuery.of(context).viewPadding.top;
    return AnnotatedRegion(
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
      leading: IconButton(
        icon: Icon(
          Icons.menu,
          color: Colors.white,
        ),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
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

  BlocBuilder header(BuildContext context) {
    return BlocBuilder<LayoutCubit, LayoutState>(
  builder: (context, state) {
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
  },
);
  }

  body(BuildContext context) {
    return BlocBuilder<LayoutCubit, LayoutState>(
      builder: (context, state) {
        LayoutCubit cubit = BlocProvider.of<LayoutCubit>(context);
        // List<BookModel> userBooks = [];
        BookModel? lastBook;
        BookMarks? bookMarks;
        UserModel? user = LayoutCubit.getUser;
        if (user!.books != null) {
          cubit.books.where(
            (element) {
              if (element.id == user.lastOpenBook &&
                  user.books!.contains(element.id)) {
                lastBook = element;
              }
              return user.books!.contains(element.id);
            },
          ).toList();

          if (user.bookMarks != null) {
            for (var element in user.bookMarks!) {
              if (element.bookId == lastBook?.id) {
                bookMarks = element;
                lastBook?.firstPage = bookMarks.pageNumber;
                lastBook?.totalPages = bookMarks.allPageNumber;
                break;
              }
            }
          }
        }
        return Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (user.books!.isNotEmpty) bodyTitle(context),
              const SizedBox(
                height: 8,
              ),
              if (user.books!.isNotEmpty && lastBook != null)
                bookProgressCard(
                  context,
                  bookName: lastBook!.name!,
                  readingPages: lastBook!.firstPage,
                  totalPages: lastBook!.totalPages,
                  bookImage: lastBook!.imageLink!,
                  book: lastBook!,
                ),
              ConditionalBuilder(
                successWidget: (_) => GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(top: 5),
                  childAspectRatio: 4 / 3,
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  children: [
                    readerProgressInfo(
                      context,
                      label: 'عدد الكتب التي قرأتها',
                      number: LayoutCubit.getUser!.numberOfBooksRead!,
                      path: 'assets/images/first.png',
                      trackName: 'numberOfBooksRead',
                    ),
                    readerProgressInfo(
                      context,
                      label: 'عدد الصفحات التي قرأتها',
                      number: LayoutCubit.getUser!.numberOfPagesRead!,
                      path: 'assets/images/se.png',
                      trackName: 'numberOfPagesRead',
                      canTap: false,
                    ),
                    readerProgressInfo(
                      context,
                      label: 'عدد الأطروحات المكتوبة',
                      number: LayoutCubit.getUser!.numberOfQuotes!,
                      path: 'assets/images/th.png',
                      trackName: 'numberOfQuotes',
                    ),
                    readerProgressInfo(
                      context,
                      label: 'عدد الصفحات المنجزة اليوم',
                      number: LayoutCubit.getUser!.numberOfPagesToday!,
                      path: 'assets/images/fo.png',
                      trackName: 'numberOfPagesToday',
                      secondNumber:LayoutCubit.getUser!.numberOfPagesRead,
                    ),
                  ],
                ),
                fallbackWidget: (_) => const Center(
                  child: CircularProgressIndicator(),
                ),
                condition: LayoutCubit.getUser != null,
              ),
            ],
          ),
        );
      },
    );
  }
}
