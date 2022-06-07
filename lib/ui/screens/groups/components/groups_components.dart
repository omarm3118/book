import 'package:book/data/models/group_model.dart';
import 'package:book/ui/screens/my_groups/controller/groups_cubit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/strings.dart';
import '../../../widgets/default_button.dart';

Text title(BuildContext context) {
  return Text(
    "قائمة الفرق ",
    style: Theme.of(context).textTheme.headlineSmall,
  );
}

Text subTitle(BuildContext context) {
  return Text(
    'اختر الفريق المناسبة لك',
    style: Theme.of(context).textTheme.labelLarge,
  );
}

ListView itemsBuilder(List<GroupModel> groups, userId) {
  return ListView.separated(
    shrinkWrap: true,
    itemBuilder: (BuildContext context, int index) =>
        itemField(context, groups[index], userId),
    separatorBuilder: (BuildContext context, int index) =>
        const Divider(height: 18),
    itemCount: groups.length,
  );
}

//Todo remove التالي button
InkWell itemField(BuildContext context, GroupModel group, userId) {
  return InkWell(
    onTap: () {
      Navigator.pushNamed(context, aboutGroupRoute,
          arguments: {'group': group});
    },
    child: Row(
      children: [
        Hero(
          tag: group.id!,
          child: Container(
            width: 68.0,
            height: 68.0,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: const Color(0xffd1cde9),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: CachedNetworkImage(
              imageUrl: group.groupImage!,
              fit: BoxFit.cover,
              errorWidget: (context, st, dy) {
                return const Icon(Icons.error_outline);
              },
            ),
          ),
        ),
        const SizedBox(
          width: 14.5,
        ),
        Text(
          group.name!,
          style: Theme.of(context).textTheme.titleMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const Spacer(),
        //Todo circle or rounded rectangle

        Stack(
          alignment: Alignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                onPrimary: group.inIt ? Colors.white : MyColors.defaultPurple,
                primary: !group.inIt ? Colors.white : MyColors.defaultPurple,
                surfaceTintColor: Colors.white,
              ),
              onPressed: () {
                if (!group.inIt) {
                  BlocProvider.of<GroupsCubit>(context)
                      .addToGroup(groupId: group.id!, userId: userId);
                }
              },
              child: group.inIt
                  ? const Icon(Icons.check)
                  : const Icon(
                      Icons.add,
                    ),
            ),
            // const CircularProgressIndicator(
            //   strokeWidth: 3,
            // ),
          ],
        ),
      ],
    ),
  );
}

DefaultButton nextButton(context) => DefaultButton(
    label: 'التالي',
    onPressed: () {
      Navigator.pushReplacementNamed(context, homeRoute);
    });
