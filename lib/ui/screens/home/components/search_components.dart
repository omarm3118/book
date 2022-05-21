import 'package:book/constants/colors.dart';
import 'package:book/constants/strings.dart';
import 'package:flutter/material.dart';

Card searchBar(context) {
  //Todo right search icon
  return Card(
    surfaceTintColor: Colors.white,
    elevation: 5,
    child: TextFormField(
      decoration: InputDecoration(
        hintText: 'ابحث',
        contentPadding:
        const EdgeInsets.only(right: 13, left: 8, bottom: 20, top: 10),
        hintStyle: Theme
            .of(context)
            .textTheme
            .titleMedium!
            .copyWith(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: const Color(0xffA7A7A7),
        ),
        suffixIcon: SizedBox(
          width: 20,
          height: 20,
          child: Row(
            children: const [
              VerticalDivider(
                indent: 12,
                endIndent: 12,
                width: 16,
                color: Color(0xffA7A7A7),
              ),
              Icon(Icons.search),
            ],
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(defaultRadius),
          borderSide: const BorderSide(color: MyColors.defaultPurple),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
        ),
      ),
    ),
  );
}

Container firstTitle(BuildContext context) {
  return Container(
    alignment: AlignmentDirectional.topEnd,
    child: Text(
      'Popular Tags',
      style: Theme
          .of(context)
          .textTheme
          .titleMedium!
          .copyWith(
        fontSize: 20,
      ),
    ),
  );
}

Row secondTitle(BuildContext context) {
  return Row(
    children: [
      Text(
        'المقترحات',
        style: Theme
            .of(context)
            .textTheme
            .titleMedium!
            .copyWith(
          fontSize: 20,
        ),
      ),
      const Spacer(),
      Text(
        'رؤية المزيد',
        style: Theme
            .of(context)
            .textTheme
            .labelLarge!
            .copyWith(
          fontSize: 14,
          color: const Color(0xff808080),
          fontWeight: FontWeight.normal,
        ),
      ),
    ],
  );
}



Wrap tags(context) {
  return Wrap(
    runSpacing: 6,
    spacing: 4,
    direction: Axis.horizontal,
    //Todo model class
    children: List.generate(
      7,
          (index) =>
          tagItems(
            context,
            isSelected: true,
            label: 'label',
          ),
    ),
  );
}

Container tagItems(context, {required bool isSelected, required String label}) {
  return Container(
    width: 75.0,
    height: 32.0,
    padding: const EdgeInsets.all(3),
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: isSelected ? MyColors.defaultPurple : const Color(0xffDCDFE3),
      borderRadius: BorderRadius.circular(32.0),
    ),
    child: Text(
      label,
      style: Theme
          .of(context)
          .textTheme
          .labelLarge!
          .copyWith(
        fontSize: 12,
        color: isSelected ? Colors.white : const Color(0xff808080),
        fontWeight: FontWeight.normal,
      ),
    ),
  );
}

SizedBox suggestions() {
  return SizedBox(
    height: 160.0,

    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemBuilder: (context, index) => bookCard(),
      itemCount: 3,
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(width: 8,);
      },
    ),
  );
}

Container bookCard() {
  return Container(
    width:108 ,
    decoration: BoxDecoration(
      color: const Color(0xffd1cde9),
      borderRadius: BorderRadius.circular(8.0),
    ),
  );
}
