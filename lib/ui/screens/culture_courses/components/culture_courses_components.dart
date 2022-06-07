import 'package:book/constants/strings.dart';
import 'package:book/data/models/courses_model.dart';
import 'package:flutter/material.dart';

import '../../../widgets/default_button.dart';

Text title(BuildContext context) {
  return Text(
    "المجالات الثقافية",
    style: Theme.of(context).textTheme.headlineSmall,
  );
}

ListView itemsBuilder(
    List<CoursesModel> items, BuildContext bookScreenContext) {
  return ListView.separated(
    shrinkWrap: true,
    itemBuilder: (BuildContext context, int index) => itemField(
        context, items[index].name, items[index].booksId, bookScreenContext),
    separatorBuilder: (BuildContext context, int index) =>
        const Divider(height: 18),
    itemCount: items.length,
  );
}

InkWell itemField(BuildContext context, String name, List booksId,
    BuildContext bookScreenContext) {
  return InkWell(
    onTap: () {
      Navigator.pushNamed(context, courseDetailsRoute, arguments: {
        'courseName':name,
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
          decoration: BoxDecoration(
            color: const Color(0xffd1cde9),
            borderRadius: BorderRadius.circular(8.0),
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
