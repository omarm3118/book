import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/strings.dart';
import '../../widgets/conditional_builder.dart';
import 'components/my_groups_components.dart';
import 'controller/groups_cubit.dart';

class MyGroupsScreen extends StatelessWidget {
  const MyGroupsScreen({Key? key}) : super(key: key);
  final List<String> items = const [
    'مجموعة التاريخ الإسلامي',
    'مجموعة الفلسفة',
    'مجموعة كتب المنطق',
  ];

  @override
  Widget build(BuildContext context) {
    GroupsCubit cubit = BlocProvider.of<GroupsCubit>(context);
    onInit(cubit);
    SystemUiOverlayStyle statusBarColor = const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    );
    return Scaffold(
      body: AnnotatedRegion(
        value: statusBarColor,
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

                BlocBuilder<GroupsCubit, GroupsState>(
                  builder: (context, state) {
                    return ConditionalBuilder(
                        successWidget: (_) => Expanded(
                              flex: 10,
                              child: cubit.myGroups.isNotEmpty
                                  ? itemsBuilder(
                                      cubit.myGroups,
                                    )
                                  : Center(
                                      child: const Text('لم تكتشف أي فريق بعد'),
                                    ),
                            ),
                        fallbackWidget: (_) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                        condition: state is! GetGroupsLoadingState);
                  },
                ),
                const Spacer(),
                buttons(context),
              ],
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
