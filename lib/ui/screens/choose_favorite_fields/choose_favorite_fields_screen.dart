import 'package:book/constants/strings.dart';
import 'package:book/ui/screens/choose_favorite_fields/controller/choose_favorite_fields_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'components/choose_favorite_fields_components.dart';

class ChooseFavoriteFieldsScreen extends StatelessWidget {
  const ChooseFavoriteFieldsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeightMinusStatusBar =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    SystemUiOverlayStyle statusBarColor = const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    );
    return Scaffold(
      body: AnnotatedRegion(
        value: statusBarColor,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: (screenHeightMinusStatusBar > maxHeight
                ? maxHeight
                : screenHeightMinusStatusBar),
            maxWidth: maxWidth,
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
                    height: 5,
                  ),
                  subTitle(context),
                  const SizedBox(
                    height: 10,
                  ),
                  //Todo convert Icon when press
                  // this take ( 9+1= 10 )  ( 9/10= 0.90)
                  Expanded(
                    flex: 9,
                    child: itemsBuilder(
                      BlocProvider.of<ChooseFavoriteFieldsCubit>(context).items,
                    ),
                  ),
                  const Spacer(),
                  nextButton(context)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
