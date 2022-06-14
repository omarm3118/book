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
              child: BlocBuilder<GroupsCubit, GroupsState>(
                builder: (context, state) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (cubit.groups.isNotEmpty) title(context),
                      const SizedBox(
                        height: 5,
                      ),
                      if (cubit.groups.isNotEmpty) subTitle(context),
                      const SizedBox(
                        height: 10,
                      ),
                      //Todo convert Icon when press  if(state is AddToGroupLoadingState)
                      //                   const LinearProgressIndicator(),
                      if (state is AddToGroupLoadingState)
                        const LinearProgressIndicator(),
                      Expanded(
                        flex: 10,
                        child: ConditionalBuilder(
                          successWidget: (_) =>
                              itemsBuilder(cubit.groups, user!.uId),
                          fallbackWidget: (_) => state is GetGroupsLoadingState
                              ? Center(
                                  child: CircularProgressIndicator(),
                                )
                              : Center(child: Text('لا يوجد أي فريق بعد')),
                          condition: state is! GetGroupsLoadingState &&
                              cubit.groups.isNotEmpty,
                        ),
                      ),

                      // this take ( 10+1= 11 )  ( 10/11= 0.93)
                      //  const Spacer(),
                      // nextButton(context)
                    ],
                  );
                },
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
