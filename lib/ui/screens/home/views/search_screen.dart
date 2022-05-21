import 'package:book/constants/colors.dart';
import 'package:book/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../components/search_components.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ));
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            searchBar(context),
            const SizedBox(
              height: 20,
            ),
            firstTitle(context),
            const SizedBox(
              height: 8,
            ),
            tags(context),
            const SizedBox(
              height: 32,
            ),
            secondTitle(context),
            const SizedBox(
              height: 12,
            ),
            suggestions(),
          ],
        ),
      ),
    );
  }

// Stack(
// children: [
// Card(
// surfaceTintColor: Colors.white,
// elevation: 5,
// child: Padding(
// padding: const EdgeInsets.only(
// right: 13, left: 8, bottom: 16, top: 16),
// child: IntrinsicHeight(
// child: Row(
// children: const [
//
// Spacer(),
// VerticalDivider(
// width: 16,
// color: Color(0xffA7A7A7),
// ),
// Icon(
// Icons.search,
// color: Color(0xffA7A7A7),
// ),
// ],
// ),
// ),
// ),
// ),
// TextFormField(
// decoration: InputDecoration(
// label:      Text(
// 'ابحث',
// style: Theme.of(context)
//     .textTheme
//     .titleMedium!
//     .copyWith(
// fontSize: 18,
// fontWeight: FontWeight.w500,
// color: const Color(0xffA7A7A7),
// ),
// ),
// contentPadding: const EdgeInsets.symmetric(horizontal: 13,vertical: 10),
// focusedBorder: UnderlineInputBorder(
// borderRadius: BorderRadius.circular(defaultRadius),
// borderSide:
// const BorderSide(color: MyColors.defaultPurple),
// ),
// enabledBorder: const UnderlineInputBorder(
// borderSide: BorderSide(color: Colors.transparent),
// ),
// ),
// ),
// ],
// ),

}
