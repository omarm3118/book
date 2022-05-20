import 'package:book/constants/strings.dart';
import 'package:book/ui/widgets/default_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../constants/colors.dart';
import 'components/choose_favorite_fields_components.dart';

class ChooseFavoriteFieldsScreen extends StatelessWidget {
  const ChooseFavoriteFieldsScreen({Key? key}) : super(key: key);
  final List<String> items = const [
    'أدب بوليسي',
    'تاريخ إسلامي',
    'تزكية وعقيدة',
    'السيرة الذاتية',
  ];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    return Scaffold(
      body: Padding(
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
                height: 5,
              ),
              subTitle(context),
              const SizedBox(
                height: 10,
              ),
              //Todo convert Icon when press
              // this take ( 9+1= 10 )  ( 9/10= 0.90)
              Expanded(flex: 9, child: itemsBuilder(items)),
              const Spacer(),
              nextButton(context)
            ],
          ),
        ),
      ),
    );
  }


}
