import 'package:book/constants/strings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../constants/colors.dart';
import '../../../../data/models/group_model.dart';
import '../../../widgets/default_button.dart';

Text title(BuildContext context) {
  return Text(
    "الفرق الخاصة بك",
    style: Theme.of(context).textTheme.headlineSmall,
  );
}

ListView itemsBuilder(List<GroupModel> groups) {
  return ListView.separated(
    shrinkWrap: true,
    itemBuilder: (BuildContext context, int index) =>
        itemField(context, groups[index]),
    separatorBuilder: (BuildContext context, int index) =>
        const Divider(height: 18),
    itemCount: groups.length,
  );
}

InkWell itemField(BuildContext context, GroupModel group) {
  return InkWell(
    onTap: () {
      Navigator.pushNamed(context, feedRoute, arguments: {
        'context': context,
        'group': group,
      });
    },
    child: Row(
      children: [
        Container(
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
        const SizedBox(
          width: 14.5,
        ),
        Flexible(
          child: Text(
            group.name!,
            style: Theme.of(context).textTheme.titleMedium,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );
}

//Todo the label of button
buttons(context) {
  return Row(
    children: [
      Expanded(
        child: DefaultButton(
          label: 'اكتشف الفرق',
          onPressed: () {
            Navigator.pushNamed(context, groupsRoute,
                arguments: {'context': context});
          },
        ),
      ),
      const SizedBox(
        width: 4,
      ),
      Expanded(
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: const BorderSide(
                color: MyColors.defaultPurple,
              )),
          onPressed: () {
            Navigator.pushNamed(context, createGroupRoute, arguments: {
              'context': context,
            });
          },
          child: Text(
            'إنشاء فريق جديد',
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: MyColors.defaultPurple,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ),
    ],
  );
}
