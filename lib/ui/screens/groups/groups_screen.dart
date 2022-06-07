import 'package:book/constants/strings.dart';
import 'package:book/data/models/user_model.dart';
import 'package:book/ui/screens/home/controller/layout_cubit.dart';
import 'package:book/ui/screens/my_groups/controller/groups_cubit.dart';
import 'package:book/ui/widgets/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'components/groups_components.dart';

class GroupsScreen extends StatelessWidget {
  GroupsScreen({Key? key}) : super(key: key);
  final UserModel? user = LayoutCubit.getUser;
  final List<String> items = const [
    'مجموعة التاريخ الإسلامي',
    'مجموعة تاريخ العرب',
    'مجموعة الفلسفة',
    'مجموعة كتب المنطق',
  ];

  @override
  Widget build(BuildContext context) {
    GroupsCubit cubit = BlocProvider.of(context);
    onInit(cubit);
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
                  BlocBuilder<GroupsCubit, GroupsState>(
                    builder: (context, state) {
                      return ConditionalBuilder(
                        successWidget: (_) => Expanded(
                            flex: 9,
                            child: Column(
                              children: [
                                if(state is AddToGroupLoadingState)
                                  const LinearProgressIndicator(),

                                  itemsBuilder(cubit.groups, user!.uId),
                              ],
                            )),
                        fallbackWidget: (_) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        condition: state is! GetGroupsLoadingState &&
                            cubit.groups.isNotEmpty,
                      );
                    },
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

  onInit(GroupsCubit cubit) {
    cubit.getAllGroups();
  }
}
