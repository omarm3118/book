import 'package:book/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'components/culture_courses_components.dart';

class CultureCoursesScreen extends StatelessWidget {
  const CultureCoursesScreen({Key? key}) : super(key: key);
  final List<String> items = const [
    'منهاج التاريخ الإسلامي',
    'منهاج الفلسفة',
    'منهاج التكنولوجيا',
    'منهاج الاقتصاد',
    '  منهاج التنمية البشرية و بناء الذات',
  ];

  @override
  Widget build(BuildContext context) {

    // SystemChrome.setSystemUIOverlayStyle(
    //   const SystemUiOverlayStyle(
    //     statusBarColor: Colors.white,
    //     statusBarIconBrightness: Brightness.dark,
    //   ),
    // );
    return Scaffold(
      body: AnnotatedRegion(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            right: defaultPadding,
            left: defaultPadding,
            top: 85,
            bottom: defaultPadding,
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                title(context),
                const SizedBox(
                  height: 10,
                ),
                //Todo convert Icon when press
                Expanded(
                  flex: 10,
                  child: itemsBuilder(items),
                ),
                const Spacer(),
                nextButton(context)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
