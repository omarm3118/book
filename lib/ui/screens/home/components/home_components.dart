import 'package:flutter/material.dart';

import '../../../../constants/colors.dart';
import '../../../widgets/default_button.dart';

Text headerWelcome(BuildContext context) {
  return Text(
    '👋 مرحبًا، عبداللّه ',
    style: Theme.of(context).textTheme.titleMedium!.copyWith(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
    maxLines: 1,
    textAlign: TextAlign.start,
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
    onPressed: () {},
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

Card bookProgressCard(context) {
  return Card(
    margin: EdgeInsets.zero,
    surfaceTintColor: Colors.white,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          bookCard(),
          const SizedBox(
            width: 7.5,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                bookTitle1(context),
                bookTitle2(context),
                bookProgressIndicator(context),
                const SizedBox(
                  height: 10,
                ),
                bookContinueButton()
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Container bookCard() {
  return Container(
    width: 108.0,
    height: 161.0,
    decoration: BoxDecoration(
      color: const Color(0xffd1cde9),
      borderRadius: BorderRadius.circular(8.0),
    ),
  );
}

Text bookTitle1(context) {
  return Text(
    'التسوق 4.0',
    style: Theme.of(context).textTheme.titleSmall,
    overflow: TextOverflow.ellipsis,
    maxLines: 1,
  );
}

Text bookTitle2(context) {
  return Text(
    'القسم الرابع',
    style: Theme.of(context).textTheme.labelLarge!.copyWith(
          fontSize: 12,
        ),
    overflow: TextOverflow.ellipsis,
    maxLines: 1,
  );
}

Row bookProgressIndicator(context) {
  return Row(
    children: [
      Expanded(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: const LinearProgressIndicator(
            value: 0.5,
            color: MyColors.defaultPurple,
            backgroundColor: Color(0xffEBEEF0),
          ),
        ),
      ),
      const SizedBox(
        width: 3,
      ),
      Text(
        '50%',
        style: Theme.of(context).textTheme.labelLarge!.copyWith(
              fontSize: 12,
            ),
      ),
    ],
  );
}

DefaultButton bookContinueButton() {
  return DefaultButton(
    label: 'أكمل',
    onPressed: () {},
  );
}

Card readerProgressInfo(context,
    {required String label, required String number, required String path}) {
  return Card(
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
            number,
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
  );
}
