import 'package:flutter/material.dart';

import '../../../../constants/strings.dart';
import '../../../widgets/default_button.dart';

Text title(BuildContext context) {
  return Text(
    "المناهج الثقافية",
    style: Theme.of(context).textTheme.headlineSmall,
  );
}

ListView itemsBuilder(items) {
  return ListView.separated(
    shrinkWrap: true,
    itemBuilder: (BuildContext context, int index) =>
        itemField(context, items[index]),
    separatorBuilder: (BuildContext context, int index) =>
        const Divider(height: 18),
    itemCount: items.length,
  );
}

Row itemField(BuildContext context, String item) {
  return Row(
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
          item,
          style: Theme.of(context).textTheme.titleMedium,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ],
  );
}

DefaultButton nextButton(context) =>
    DefaultButton(label: 'اقتراح منهاج جديد', onPressed: () {});
