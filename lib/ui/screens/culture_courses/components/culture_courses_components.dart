import 'package:book/constants/colors.dart';
import 'package:book/constants/strings.dart';
import 'package:book/data/models/courses_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../widgets/default_button.dart';

Text title(BuildContext context) {
  return Text(
    "المناهج الثقافية",
    style: Theme.of(context).textTheme.headlineSmall,
  );
}

GridView itemsBuilder(
    List<CoursesModel> items, BuildContext bookScreenContext) {
  return GridView.builder(
    shrinkWrap: true,
    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
      maxCrossAxisExtent: 240,
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      mainAxisExtent: 230,

    ),
    itemBuilder: (BuildContext context, int index) => Column(
      children: [
        Expanded(
          child: itemField2(
            context: context,
            name: items[index].name,
            booksId: items[index].booksId,
            bookScreenContext: bookScreenContext,
            imageLink: items[index].imageLink,
          ),
        ),
        if (index == items.length - 1)
          SizedBox(
            height: 10,
          ),
      ],
    ),
    itemCount: items.length,
  );
}

InkWell itemField({
  required BuildContext context,
  required String name,
  required List booksId,
  required BuildContext bookScreenContext,
  String? imageLink,
}) {
  return InkWell(
    onTap: () {
      Navigator.pushNamed(context, courseDetailsRoute, arguments: {
        'courseName': name,
        'booksId': booksId,
        'context': context,
        'bookScreenContext': bookScreenContext,
      });
    },
    child: Row(
      children: [
        Container(
          width: 68.0,
          height: 68.0,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: const Color(0xffd1cde9),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: CachedNetworkImage(
            imageUrl: imageLink ?? '',
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(
          width: 14.5,
        ),
        Flexible(
          child: Text(
            'مجال $name',
            style: Theme.of(context).textTheme.titleMedium,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );
}

DefaultButton nextButton(context) =>
    DefaultButton(label: 'اقتراح منهاج جديد', onPressed: () {});

InkWell itemField2({
  required BuildContext context,
  required String name,
  required List booksId,
  required BuildContext bookScreenContext,
  String? imageLink,
}) {
  return InkWell(
    onTap: () {
      Navigator.pushNamed(context, courseDetailsRoute, arguments: {
        'courseName': name,
        'booksId': booksId,
        'context': context,
        'bookScreenContext': bookScreenContext,
      });
    },
    child: Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: MyColors.defaultPurple,width: 0.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Card(
            margin: EdgeInsets.zero,
            surfaceTintColor: Colors.white,
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Column(
                children: [
                  Container(
                    width: 138.0,
                    height: 151.0,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: const Color(0xffd1cde9),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: imageLink ?? '',
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    height: 7.5,
                  ),
                  Text(
                    'مجال $name',
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 5,),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 20,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: MyColors.defaultPurple,
                        borderRadius: BorderRadius.vertical(bottom: Radius.circular(8)),

                      ),
                    ),
                  ),
                ],
              ),
            ),

            // child: CachedNetworkImage(
            //   imageUrl: imageLink??'',
            //   fit: BoxFit.cover,
            // ),
          ),
        ),
      ],
    ),
  );
}
