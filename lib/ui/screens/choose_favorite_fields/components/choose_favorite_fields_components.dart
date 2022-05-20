import 'package:flutter/material.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/strings.dart';
import '../../../widgets/default_button.dart';

Text title(BuildContext context) {
  return Text(
    "اختر المجالات المفضلة",
    style: Theme.of(context).textTheme.headlineSmall,
  );
}

Text subTitle(BuildContext context) {
  return Text(
    'خصص التطبيق حسب المجالات المهتم بها',
    style: Theme.of(context).textTheme.labelLarge,
  );
}



ListView itemsBuilder(items) {
  return ListView.separated(
    shrinkWrap: true,
    itemBuilder: (BuildContext context, int index) =>
        fieldItem(context, items[index]),
    separatorBuilder: (BuildContext context, int index) =>
    const Divider(height: 18),
    itemCount: items.length,
  );
}

Row fieldItem(BuildContext context, String item) {
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
      Text(
        item,
        style: Theme.of(context).textTheme.titleMedium,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      const Spacer(),
      //Todo circle or rounded rectangle

      ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          onPrimary: MyColors.defaultPurple,
          primary: Colors.white,
          surfaceTintColor: Colors.white,

        ),
        onPressed: () {},
        child: const Icon(
          Icons.add,
        ),
      ),
    ],
  );
}
DefaultButton nextButton(context) => DefaultButton(label: 'التالي', onPressed: () {
  Navigator.pushReplacementNamed(context, homeRoute);
});