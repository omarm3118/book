import 'package:book/constants/colors.dart';
import 'package:book/constants/strings.dart';
import 'package:book/data/models/book_model.dart';
import 'package:book/ui/screens/home/controller/layout_cubit.dart';
import 'package:book/ui/widgets/conditional_builder.dart';
import 'package:book/ui/widgets/default_button.dart';
import 'package:book/ui/widgets/rating_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class BookDetailsScreen extends StatelessWidget {
  final BookModel book;

  const BookDetailsScreen({required this.book, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemUiOverlayStyle statusBarColor = const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    );
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: statusBarColor,
      ),
      body: BlocBuilder<LayoutCubit, LayoutState>(
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      children: [
                        Card(
                          margin: EdgeInsets.zero,
                          child: Container(
                            color: Colors.white,
                            height: 220,
                            width: double.infinity,
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 22.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Hero(
                                  tag: book.id.toString(),
                                  child: Card(
                                    color: Colors.transparent,
                                    margin: EdgeInsets.zero,
                                    child: Container(
                                      height: 240,
                                      width: 160,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(
                                        color: const Color(0xffd1cde9),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        imageUrl: book.imageLink.toString(),
                                        errorWidget: (ctx, url, error) =>
                                            const Icon(Icons.error_outline),
                                        placeholder: (ctx, url) => const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 14,
                                ),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        book.name.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w600,
                                            ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        book.authorName.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .copyWith(
                                              fontWeight: FontWeight.w400,
                                            ),
                                      ),
                                      //Todo stars
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      ConditionalBuilder(
                                        successWidget: (_) => ratingIndicator(
                                            book.bookRate, context),
                                        fallbackWidget: (context) => SizedBox(
                                          width: 50,
                                          child: Container(
                                            clipBehavior: Clip.antiAlias,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(3)),
                                            child:
                                                const LinearProgressIndicator(
                                              backgroundColor: Colors.grey,
                                            ),
                                          ),
                                        ),
                                        condition:
                                            state is! GetRateLoadingState,
                                      ),
                                      const SizedBox(
                                        height: 21,
                                      ),

                                      SizedBox(
                                        height: 44,
                                        width: 155,
                                        child: DefaultButton(
                                          label: 'اقرأ الآن',
                                          labelStyle: const TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          onPressed: () {
                                            Navigator.pushNamed(
                                              context,
                                              pdfViewerRoute,
                                              arguments: {
                                                'bookId': book.id,
                                                'url': book.pdfLink,
                                                'bookName': book.name,
                                                'context': context,
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 28,
                          ),
                          description(context),
                          const SizedBox(
                            height: 45,
                          ),
                          ConditionalBuilder(
                            successWidget: (_) => reviews(context),
                            fallbackWidget: (_) => const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: RefreshProgressIndicator(),
                            ),
                            condition: state is! GetRateLoadingState,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }

  ConditionalBuilder reviews(BuildContext context) {
    return ConditionalBuilder(
      successWidget: (_) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'المراجعات (${book.bookReviews.length})',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Colors.purple[50]!,
                      builder: (_) {
                        return Directionality(
                          textDirection: TextDirection.rtl,
                          child: ListView.separated(
                            padding: const EdgeInsets.all(24),
                            itemBuilder: (BuildContext context, int index) =>
                                commentItem(context, book.bookReviews[index]),
                            itemCount: book.bookReviews.length,
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    const SizedBox(
                              height: 20,
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Text(
                    'رؤية المزيد',
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 11,
            ),
            commentItem(context, book.bookReviews[0]),
          ],
        ),
      ),
      fallbackWidget: (_) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          'لا مراجعات بعد',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
      condition: book.bookReviews.isNotEmpty,
    );
  }

  Padding description(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 38),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'عن الكتاب',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(
            height: 7,
          ),
          Text(
            book.description.toString(),
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: const Color(0xff808080), fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }

  ratingDialog(context) {
    return showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: RatingDialog(
          title: const Text('قيّم هذا الكتاب'),
          commentHint: 'أخبرنا رأيك عن الكتاب',
          submitButtonText: 'أرسل',
          starColor: MyColors.defaultPurple,
          starSize: 30,
          onSubmitted: (RatingDialogResponse rating) {
            LayoutCubit.getCubit(context).pushBookRate(
              bookId: book.id!,
              comment: rating.comment,
              bookRate: rating.rating,
            );
          },
        ),
      ),
    );
  }

  ratingIndicator(double rate, context) {
    return InkWell(
      onTap: () {
        ratingDialog(context);
      },
      child: RatingBarIndicator(
        itemSize: 16,
        rating: rate.roundToDouble(),
        itemBuilder: (context, _) => const Icon(
          Icons.star,
          color: Color(0xffFFCA54),
        ),
      ),
    );
  }

  commentItem(BuildContext context, BookReview review) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xffD1CDE9),
              ),
            ),
            const SizedBox(
              width: 6,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${LayoutCubit.getUser?.name.toString()}',
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(
                  height: 3,
                ),
                ratingIndicator(review.bookRate!, context),
              ],
            ),
            const SizedBox(
              width: 3,
            ),
            //var date = new DateTime.fromMicrosecondsSinceEpoch(timestamp);
            Text(
              review.date.toString(),
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    height: 1.2,
                    fontSize: 12,
                    color: const Color(0xff808080),
                    fontWeight: FontWeight.w400,
                  ),
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.start,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          review.bookComment!.toString(),
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: const Color(0xff808080),
                fontWeight: FontWeight.w400,
              ),
        ),
      ],
    );
  }
}
