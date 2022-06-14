import 'package:book/constants/colors.dart';
import 'package:book/data/models/group_model.dart';
import 'package:book/ui/screens/home/controller/layout_cubit.dart';
import 'package:book/ui/screens/my_groups/controller/groups_cubit.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/strings.dart';
import 'components/feed_message_components.dart';
import 'components/feed_poll_components.dart';
import 'components/feed_post_components.dart';

class FeedScreen extends StatelessWidget {
  FeedScreen({Key? key, required this.group}) : super(key: key);
  final GroupModel group;
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    GroupsCubit cubit = BlocProvider.of<GroupsCubit>(context);

    onInit(cubit);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          leading: const BackButton(
            color: Colors.white,
          ),
          backgroundColor: MyColors.defaultBackgroundPurple,
          // titleSpacing: 0,
          title: searchBar(context, cubit),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  newPostRoute,
                  arguments: {'context': context, 'group': group},
                );
              },
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
            if (group.admins!.contains(LayoutCubit.getUser!.uId))
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    pollsRoute,
                    arguments: {
                      'context': context,
                      'groupId': group.id,
                    },
                  );
                },
                icon: const Icon(
                  Icons.poll_outlined,
                  color: Colors.white,
                ),
              ),
            IconButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  showGroupUsersRoute,
                  arguments: {'users':group.members},
                );
              },
              icon: const Icon(
                Icons.supervised_user_circle_sharp,
                color: Colors.white,
              ),
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(
                text: 'المنشورات',
              ),
              Tab(
                text: 'التصويتات',
              ),
              Tab(
                text: 'الرسائل',
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            FeedPostComponents(
              cubit: cubit,
              group: group,
              searchController: searchController,
            ),
            FeedPollComponents(
              cubit: cubit,
              group: group,
            ),
            FeedMessageComponents(
              group: group,
              cubit: cubit,
            ),
          ],
        ),
      ),
    );
  }

  Container searchBar(BuildContext context, cubit) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: TextFormField(
        controller: searchController,
        decoration: InputDecoration(
          hintText: 'البحث',
          contentPadding: EdgeInsets.zero,
          hintStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: const Color(0xffA7A7A7),
              ),
          suffixIcon: SizedBox(
            width: 20,
            child: Row(
              children: const [
                VerticalDivider(
                  indent: 12,
                  endIndent: 12,
                  width: 16,
                  color: Color(0xffA7A7A7),
                ),
                // cubit.isSearch
                Icon(Icons.search),
              ],
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: const BorderSide(color: MyColors.defaultPurple),
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
        ),
        onTap: () {
          cubit.openSearch(context);
          // showSearch(context: context, delegate: MySearchDelegate());
        },
        onChanged: (query) {
          cubit.openSearch(context);
        },
      ),
    );
  }

  Future<void> onInit(GroupsCubit cubit) async {
    cubit.getGroupPolls(groupId: group.id!);
    cubit.getGroupPosts(groupId: group.id!);
    cubit.getMessages(groupId: group.id!);
  }
}
