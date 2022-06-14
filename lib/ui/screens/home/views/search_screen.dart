import 'package:book/constants/strings.dart';
import 'package:book/ui/screens/home/controller/layout_cubit.dart';
import 'package:book/ui/widgets/conditional_builder.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../constants/colors.dart';
import '../../../../data/models/book_model.dart';
import '../../../../data/models/user_model.dart';
import '../../../widgets/default_button.dart';
import '../components/search_components.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({Key? key}) : super(key: key);

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    LayoutCubit cubit =
        BlocProvider.of<LayoutCubit>(context); //LayoutCubit.getCubit(context);
    SystemUiOverlayStyle statusBarColor = const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    );
    return AnnotatedRegion(
      value: statusBarColor,
      child: BlocBuilder<LayoutCubit, LayoutState>(
        builder: (_, state) {
          List<BookModel> userBooks = [];
          UserModel? user = LayoutCubit.getUser;
          if (user!.books != null) {
            userBooks = cubit.books.where(
              (element) {
                if (element.id == user.lastOpenBook &&
                    user.books!.contains(element.id)) {}
                return user.books!.contains(element.id);
              },
            ).toList();
          }
          if (state is ExitSearchState) {
            searchController.clear();
          }
          return SafeArea(
            child: ConditionalBuilder(
              successWidget: (_) => Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      searchBar(context, cubit, searchController),
                      const SizedBox(
                        height: 20,
                      ),
                      //      firstTitle(context),
                      const SizedBox(
                        height: 8,
                      ),

                      // tags(context),
                      //  const SizedBox(
                      //    height: 32,
                      //  ),
                      secondTitle(
                        context: context,
                        books: cubit.books,
                        title: 'المقترحات',
                        hasShowMore: true,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      suggestions(cubit.books),

                      SizedBox(
                        height: 32,
                      ),

                      secondTitle(
                        context: context,
                        books: cubit.books,
                        title: ' رف الكتب الخاص بك',
                        hasShowMore: false,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Flexible(
                        child: bookShelf(
                          userBooks: userBooks,
                          user: user,
                          context: context,
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                    ],
                  ),
                ),
              ),
              fallbackWidget: (_) => Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  searchBar(
                    context,
                    cubit,
                    searchController,
                  ),
                  Flexible(
                    child: searchList(
                        books: cubit.books, query: searchController.text),
                  ),
                ],
              ),
              condition: !cubit.isSearch,
            ),
          );
        },
      ),
    );
  }

  bookShelf({
    required List<BookModel> userBooks,
    required UserModel user,
    required BuildContext context,
  }) {
    return ConditionalBuilder(
      successWidget: (_) => GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 250,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: 2 / 4,
        ),
        itemBuilder: (context, index) {
          return userBooksCard(
            book: userBooks[index],
            user: user,
            context: context,
          );
        },
        itemCount: userBooks.length,
      ),
      condition: userBooks.isNotEmpty,
      fallbackWidget: (BuildContext) => Center(
        child: Text(
          'لم تختر أي كتاب بعد',
        ),
      ),
    );
  }

  userBooksCard({
    required BookModel book,
    required UserModel user,
    required BuildContext context,
  }) {
    if (user.bookMarks != null) {
      for (var element in user.bookMarks!) {
        if (element.bookId == book.id) {
          book.firstPage = element.pageNumber;
          book.totalPages = element.allPageNumber;
          break;
        }
      }
    }
    return shelfBookProgressCard(
      context,
      bookName: book.name!,
      readingPages: book.firstPage,
      totalPages: book.totalPages,
      bookImage: book.imageLink!,
      book: book,
    );
  }

  Card shelfBookProgressCard(
    context, {
    required String bookName,
    required int readingPages,
    required int totalPages,
    required String bookImage,
    required BookModel book,
  }) {
    double bookTrack = readingPages / totalPages;
    return Card(
      margin: EdgeInsets.zero,
      surfaceTintColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            shelfBookCard(bookImage),
            const SizedBox(
              height: 7.5,
            ),
            shelfBookTitle1(context, bookName: bookName),
            shelfBookTitle2(context, book.authorName!),
            shelfBookProgressIndicator(context, bookTrack: bookTrack),
            const SizedBox(
              height: 10,
            ),
            shelfBookContinueButton(context, book)
          ],
        ),
      ),
    );
  }

  Container shelfBookCard(String bookImage) {
    return Container(
      width: 108.0,
      height: 151.0,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xffd1cde9),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: CachedNetworkImage(
        imageUrl: bookImage,
        fit: BoxFit.cover,
      ),
    );
  }

  Text shelfBookTitle1(context, {required String bookName}) {
    return Text(
      bookName,
      style: Theme.of(context).textTheme.titleSmall,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    );
  }

  Text shelfBookTitle2(context, String authorName) {
    return Text(
      authorName,
      style: Theme.of(context).textTheme.labelLarge!.copyWith(
            fontSize: 12,
          ),
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    );
  }

  Row shelfBookProgressIndicator(context, {required double bookTrack}) {
    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: bookTrack,
              color: MyColors.defaultPurple,
              backgroundColor: const Color(0xffEBEEF0),
            ),
          ),
        ),
        const SizedBox(
          width: 3,
        ),
        Text(
          '${(bookTrack * 100).roundToDouble()}%',
          style: Theme.of(context).textTheme.labelLarge!.copyWith(
                fontSize: 12,
              ),
        ),
      ],
    );
  }

  SizedBox shelfBookContinueButton(context, BookModel book) {
    return SizedBox(
      height: 40,
      child: DefaultButton(
        label: 'أكمل',
        onPressed: () {
          Navigator.pushNamed(
            context,
            pdfViewerRoute,
            arguments: {
              'context': context,
              'bookId': book.id,
              'url': book.pdfLink,
              'bookName': book.name,
              'book': book,
            },
          );
        },
      ),
    );
  }
}
