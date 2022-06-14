import 'package:book/data/models/user_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../constants/strings.dart';
import '../home/controller/layout_cubit.dart';

class ShowGroupUsersScreen extends StatelessWidget {
  ShowGroupUsersScreen({Key? key, required this.users}) : super(key: key);
  List users;

  @override
  Widget build(BuildContext context) {
    List<UserModel>? groupUsers = LayoutCubit.allUsers
        ?.where((element) => users.contains(element.uId))
        .toList();
    return Scaffold(
      body: ListView.builder(
        itemCount: groupUsers!.length,
        itemBuilder: (context, index) => ListTile(
          onTap: () {
            Navigator.pushNamed(
              context,
              userDetailsRoute,
              arguments: {
                'user': groupUsers![index],
                'heroId': groupUsers[index].uId,
              },
            );
          },
          leading: CircleAvatar(
            child: CachedNetworkImage(
              imageUrl: groupUsers![index].image,
            ),
          ),
          title: Text(groupUsers[index].name),
          subtitle: Text(groupUsers[index].email),
        ),
      ),
    );
  }
}
