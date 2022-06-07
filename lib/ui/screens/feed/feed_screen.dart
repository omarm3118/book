import 'package:book/constants/colors.dart';
import 'package:book/data/models/group_model.dart';
import 'package:book/ui/screens/home/controller/layout_cubit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../constants/strings.dart';
import '../../../data/models/user_model.dart';

class FeedScreen extends StatelessWidget {
  FeedScreen({Key? key, required this.group}) : super(key: key);
  final UserModel? user = LayoutCubit.getUser;
  final GroupModel group;
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.white,
        ),
        backgroundColor: MyColors.defaultBackgroundPurple,
        // titleSpacing: 0,
        title: Container(
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
              contentPadding:  EdgeInsets.zero,
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
              //  cubit.openSearch(context);
              // showSearch(context: context, delegate: MySearchDelegate());
            },
            onChanged: (query) {
              //    cubit.openSearch(context);
            },
          ),
        ),
      ),
      body: ListView.separated(
        itemBuilder: (context, index) => itemBuilder(context),
        separatorBuilder: (context, index) => const SizedBox(
          height: 5,
        ),
        itemCount: 1,
      ),
    );
  }

  itemBuilder(context) {
    return Card(
      surfaceTintColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                radius: 25,
                backgroundColor: Colors.grey.withOpacity(0.5),
                backgroundImage: CachedNetworkImageProvider(
                  user!.image,
                ),
              ),
              title: Text(
                user!.name,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
              ),
              subtitle: Text(
                group.createdAt!,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      height: 1.2,
                      fontSize: 12,
                      color: const Color(0xff808080),
                      fontWeight: FontWeight.w400,
                    ),
              ),
            ),
            const SizedBox(
              height: 19,
            ),
            Text(
              group.groupBio!,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: const Color(0xff808080),
                    fontWeight: FontWeight.w400,
                  ),
            ),
            const SizedBox(
              height: 11,
            ),
            Container(
              width: 347,
              height: 193,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(4)),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    primary: MyColors.defaultPurple,
                    onPrimary: Colors.white,
                    maximumSize: const Size(64, 30),
                    minimumSize: const Size(64, 30),
                  ),
                  icon: const Icon(
                    Icons.dataset_linked_outlined,
                    size: 15,
                  ),
                  label: const Text('27'),
                  onPressed: () {},
                ),
                const Spacer(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    primary: MyColors.defaultPurple,
                    onPrimary: Colors.white,
                    maximumSize: const Size(30, 30),
                    minimumSize: const Size(30, 30),
                  ),
                  child: const Icon(
                    Icons.comment_outlined,
                    size: 15,
                  ),
                  onPressed: () {},
                ),
                const SizedBox(
                  width: 3,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    primary: MyColors.defaultPurple,
                    onPrimary: Colors.white,
                    maximumSize: const Size(30, 30),
                    minimumSize: const Size(30, 30),
                  ),
                  child: const Icon(
                    Icons.bookmark_border,
                    size: 15,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
