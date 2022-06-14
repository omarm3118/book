import 'package:book/constants/strings.dart';
import 'package:book/data/models/book_model.dart';
import 'package:book/data/repositories/firebase_storage_repository.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../constants/colors.dart';
import '../../../../data/repositories/firebase_firestore_repository.dart';
import '../../../widgets/default_button.dart';
import '../controller/layout_cubit.dart';

Text headerWelcome(BuildContext context) {
  return Text(
    '👋 مرحبًا، ${LayoutCubit.getUser?.name} ',
    style: Theme.of(context).textTheme.titleMedium!.copyWith(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
    maxLines: 2,
    textAlign: TextAlign.center,
    overflow: TextOverflow.ellipsis,
  );
}

Text headerTitle(BuildContext context) {
  return Text(
    'ماذا تريد أن تقرأ اليوم؟',
    style: Theme.of(context).textTheme.labelLarge!.copyWith(
          color: const Color(0xff9B91D6),
          fontSize: 16,
        ),
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
  );
}

OutlinedButton goToCoursesButton(BuildContext context) {
  return OutlinedButton(
    style: OutlinedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7),
      ),
      minimumSize: const Size(0, 0),
    ),
    onPressed: () {
      Navigator.pushNamed(
        context,
        cultureCoursesRoute,
        arguments: {'context': context},
      );
    },
    child: Text(
      'المناهج الثقافية',
      style: Theme.of(context).textTheme.labelLarge!.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
    ),
  );
}

Text bodyTitle(BuildContext context) {
  return Text(
    'أكمل القراءة',
    style: Theme.of(context).textTheme.titleMedium!.copyWith(
          fontSize: 20,
        ),
  );
}

Card bookProgressCard(
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
      child: Row(
        children: [
          bookCard(bookImage),
          const SizedBox(
            width: 7.5,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                bookTitle1(context, bookName: bookName),
                bookTitle2(context, book.authorName!),
                bookProgressIndicator(context, bookTrack: bookTrack),
                const SizedBox(
                  height: 10,
                ),
                bookContinueButton(context, book)
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Container bookCard(String bookImage) {
  return Container(
    width: 108.0,
    height: 161.0,
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

Text bookTitle1(context, {required String bookName}) {
  return Text(
    bookName,
    style: Theme.of(context).textTheme.titleSmall,
    overflow: TextOverflow.ellipsis,
    maxLines: 1,
  );
}

Text bookTitle2(context, String authorName) {
  return Text(
    authorName,
    style: Theme.of(context).textTheme.labelLarge!.copyWith(
          fontSize: 12,
        ),
    overflow: TextOverflow.ellipsis,
    maxLines: 1,
  );
}

Row bookProgressIndicator(context, {required double bookTrack}) {
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

DefaultButton bookContinueButton(context, BookModel book) {
  return DefaultButton(
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
  );
}

InkWell readerProgressInfo(
  context, {
  required String label,
  required int number,
  int? secondNumber,
  required String path,
  required String trackName,
}) {
  return InkWell(
    onTap: () {
      showDialog(
        context: context,
        builder: (_) {
          return BlocProvider(
            create: (ctx) => LayoutCubit(
              firebaseFirestoreRepository: FirebaseFirestoreRepository(),
              firebaseStorageRepository: FirebaseStorageRepository(),
            ),
            child: BlocConsumer<LayoutCubit, LayoutState>(
              listener: (context, state) {
                if (state is UpdateTrackSuccessState) {
                  Navigator.pop(context);
                }
              },
              builder: (context, state) {
                return Dialog(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: SizedBox(
                    height: 300,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              height: 130,
                              width: 250,
                              clipBehavior: Clip.antiAlias,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20)),
                              ),
                              child: Image.asset(
                                'assets/images/book_animation.gif',
                                cacheWidth: 750,
                                cacheHeight: 390,
                                width: 750,
                                height: 390,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 150,
                            child: Card(
                              elevation: 0,
                              surfaceTintColor: Colors.white,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              defaultRadius,
                                            ),
                                          ),
                                          minimumSize: const Size(50, 50),
                                          maximumSize: const Size(50, 50),
                                        ),
                                        onPressed: () {
                                          if (number != 0) {
                                            number--;
                                            if (secondNumber != null) {
                                              secondNumber =
                                                  (secondNumber! - 1);
                                            }
                                            BlocProvider.of<LayoutCubit>(
                                                    context)
                                                .changeNumber();
                                          }
                                        },
                                        child: const Text(
                                          '-',
                                          style: TextStyle(fontSize: 30),
                                        ),
                                      ),
                                      Text(number.toString()),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              defaultRadius,
                                            ),
                                          ),
                                          minimumSize: const Size(50, 50),
                                          maximumSize: const Size(50, 50),
                                        ),
                                        onPressed: () {
                                          number++;
                                          if (secondNumber != null) {
                                            secondNumber = (secondNumber! + 1);
                                          }
                                          BlocProvider.of<LayoutCubit>(context)
                                              .changeNumber();
                                        },
                                        child: const Icon(Icons.add),
                                      )
                                    ],
                                  ),
                                  const Spacer(),
                                  SizedBox(
                                    width: 320,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: TextButton(
                                            onPressed: () async {
                                              await BlocProvider.of<
                                                      LayoutCubit>(context)
                                                  .updateUserTrack(
                                                userId:
                                                    LayoutCubit.getUser!.uId,
                                                trackName: trackName,
                                                tracValue: number,
                                                secondTrackName: trackName ==
                                                        'numberOfPagesToday'
                                                    ? 'numberOfPagesRead'
                                                    : null,
                                                secondTrackValue: trackName ==
                                                        'numberOfPagesToday'
                                                    ? secondNumber
                                                    : null,
                                              );
                                            },
                                            child: const Text(
                                              'تأكيد الإنجاز',
                                            ),
                                          ),
                                        ),
                                        if (state is UpdateTrackLoadingState)
                                          const RefreshProgressIndicator()
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      );
    },
    child: Card(
      margin: const EdgeInsets.all(2),
      surfaceTintColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(9),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.w300,
                  ),
            ),
            //Todo hero animation
            Text(
              number.toString(),
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Flexible(
              child: Align(
                alignment: AlignmentDirectional.bottomEnd,
                child: Image.asset(
                  path,
                  alignment: AlignmentDirectional.bottomEnd,
                  width: double.infinity,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

NavigationBar navigationBar(layoutCubit, context) {
  return NavigationBar(
    selectedIndex: layoutCubit.navBarIndex,
    onDestinationSelected: (int index) {
      if (index == 3) {
        Navigator.pushNamed(
          context,
          myGroupsRoute,
        );
      } else {
        layoutCubit.changeNavBar(index);
      }
    },
    destinations: [
      NavigationDestination(
        icon: SvgPicture.asset(
          'assets/icon_svgs/icon_home.svg',
          color: Colors.grey,
        ),
        selectedIcon: SvgPicture.asset(
          'assets/icon_svgs/icon_home.svg',
          color: MyColors.defaultPurple,
        ),
        label: '',
      ),
      NavigationDestination(
        icon: SvgPicture.asset(
          'assets/icon_svgs/icon_search.svg',
          color: MyColors.defaultIconColor,
        ),
        selectedIcon: SvgPicture.asset(
          'assets/icon_svgs/icon_search.svg',
          color: MyColors.defaultPurple,
        ),
        label: '',
      ),
      NavigationDestination(
        icon: SvgPicture.asset(
          'assets/icon_svgs/icon_bookmark.svg',
          color: MyColors.defaultIconColor,
        ),
        selectedIcon: SvgPicture.asset(
          'assets/icon_svgs/icon_bookmark.svg',
          color: MyColors.defaultPurple,
        ),
        label: '',
      ),
      NavigationDestination(
        icon: SvgPicture.asset(
          'assets/icon_svgs/icon_social.svg',
          color: MyColors.defaultIconColor,
        ),
        selectedIcon: SvgPicture.asset(
          'assets/icon_svgs/icon_social.svg',
          color: MyColors.defaultPurple,
        ),
        label: '',
      ),
    ],
  );
}
