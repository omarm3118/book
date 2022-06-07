import 'package:book/constants/strings.dart';
import 'package:book/data/models/book_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../constants/colors.dart';
import '../../../widgets/default_button.dart';

Text headerWelcome(BuildContext context, courseName) {
  return Text(
    'مجال $courseName',
    style: Theme.of(context).textTheme.titleMedium!.copyWith(
          color: Colors.white,
          fontSize: 30,
          fontWeight: FontWeight.w600,
        ),
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
    textAlign: TextAlign.start,
  );
}

bodyTitle(BuildContext context, courseName) {
  return Center(
    child: Text(
      ' مناهج القراءة في مجال $courseName',
      style: Theme.of(context).textTheme.titleMedium!.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    ),
  );
}

Card bodyCard(context, book1, index) {
  return Card(
    surfaceTintColor: Colors.white,
    child: Padding(
      padding: const EdgeInsets.only(
        top: 4,
        bottom: 4,
        right: 6,
        left: 4,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          bookCard(context, book1, index),
          const SizedBox(
            height: 9,
          ),
//if (book2 != null) bookCard(context, book2),
        ],
      ),
    ),
  );
}

bookCard(context, BookModel book, index) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Container(
        height: 88,
        width: 58,
        clipBehavior: Clip.antiAlias,
        decoration:  BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: MyColors.defaultIconColor,
        ),
        child: CachedNetworkImage(
          imageUrl: book.imageLink!,
          fit: BoxFit.cover,
        ),
      ),
      const SizedBox(
        width: 5,
      ),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              book.name!,
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    fontWeight: FontWeight.w600,

                  ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(
              height: 4,
            ),
            SizedBox(
              height: 26,
              width: 120,
              child: DefaultButton(
                label: 'اقرأ',
                labelStyle: const TextStyle(
                  fontSize: 9,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, bookDetailsRoute, arguments: {
                    'book': book,
                    'context': context,
                  });
                },
              ),
            ),
          ],
        ),
      ),

      //const Spacer(),
      Text(
        'المستوى ${index+1}',
        style: Theme.of(context).textTheme.labelSmall!.copyWith(
              fontSize: 10,
              fontWeight: FontWeight.w300,
            ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    ],
  );
}
