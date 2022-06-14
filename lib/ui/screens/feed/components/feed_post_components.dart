import 'package:book/data/models/group_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/strings.dart';
import '../../../../data/models/post_model.dart';
import '../../../../data/models/user_model.dart';
import '../../../widgets/conditional_builder.dart';
import '../../../widgets/toast.dart';
import '../../home/controller/layout_cubit.dart';
import '../../my_groups/controller/groups_cubit.dart';

class FeedPostComponents extends StatelessWidget {
  FeedPostComponents({
    Key? key,
    required this.cubit,
    required this.group,
    required this.searchController,
  }) : super(key: key);
  final TextEditingController searchController;
  final UserModel? user = LayoutCubit.getUser;
  final List<UserModel>? users = LayoutCubit.allUsers;
  final GroupsCubit cubit;
  final GroupModel group;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GroupsCubit, GroupsState>(
      listener: (context, state) {
        if (state is SavePostSuccessState)
          showingToast(msg: '✔', state: ToastState.checked, isGravityTop: true);
      },
      builder: (context, state) {
        bool isSearch = false;
        List<PostModel> searches = [];

        if (searchController.text.isNotEmpty) {
          isSearch = true;
          searches = cubit.posts
              .where((element) =>
                  (element.text!.toLowerCase().contains(
                        searchController.text.toLowerCase(),
                      )) ||
                  (element.dateTime.toLowerCase().contains(
                        searchController.text.toLowerCase(),
                      )))
              .toList();
        }
        return ConditionalBuilder(
          successWidget: (_) => ConditionalBuilder(
            successWidget: (_) => ListView.separated(
              itemBuilder: (context, index) => _postItemBuilder(
                context,
                isSearch ? searches[index] : cubit.posts[index],
                cubit,
                (state is SavePostLoadingState),
              ),
              separatorBuilder: (context, index) => const SizedBox(
                height: 5,
              ),
              itemCount: isSearch ? searches.length : cubit.posts.length,
            ),
            fallbackWidget: (_) => const Center(child: Text('لا منشورات بعد')),
            condition: cubit.posts.isNotEmpty,
          ),
          fallbackWidget: (_) => const Center(
            child: CircularProgressIndicator(),
          ),
          condition: state is! GetPostsLoadingState &&
              state is! GetMessagesLoadingState,
        );
      },
    );
  }

  _postItemBuilder(context, PostModel post, cubit, bool isSaveLoading) {
    UserModel userWhoMakeThePost =
        users!.firstWhere((element) => element.uId == post.userId);

    return Card(
      surfaceTintColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            userInfo(context, userWhoMakeThePost, post.dateTime, post),
            const SizedBox(
              height: 19,
            ),
            if (post.text != null && post.text!.isNotEmpty)
              postText(context, post.text!),
            const SizedBox(
              height: 11,
            ),
            if (post.image != null && post.image!.isNotEmpty)
              postImage(post, cubit),
            const SizedBox(
              height: 20,
            ),
            postReactions(
              context,
              post.isLike,
              cubit,
              post.postId,
              post.likes.length,
              post,
              isSaveLoading,
            ),
          ],
        ),
      ),
    );
  }

  Row postReactions(
    context,
    bool isLike,
    GroupsCubit cubit,
    postId,
    postLikesLength,
    PostModel post,
    bool isSaveLoading,
  ) {
    return Row(
      children: [
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            primary: isLike ? MyColors.defaultPurple : Colors.white,
            onPrimary: Colors.white,
            maximumSize: const Size(64, 30),
            minimumSize: const Size(64, 30),
          ),
          icon: SvgPicture.asset(
            'assets/icon_svgs/icon_like.svg',
            color: isLike ? Colors.white : MyColors.defaultPurple,
          ),
          label: Text(
            postLikesLength.toString(),
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: isLike ? Colors.white : MyColors.defaultPurple,
                ),
          ),
          onPressed: () {
            cubit.likePost(
              groupId: group.id!,
              postId: postId,
              isLike: isLike,
              userId: user!.uId,
            );
          },
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
          child: SvgPicture.asset(
            'assets/icon_svgs/icon_comment.svg',
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushNamed(context, commentRoute, arguments: {
              'context': context,
              'post': post,
              'groupId': group.id,
              'userId': user!.uId,
            });
          },
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
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (isSaveLoading)
                const CircularProgressIndicator(
                  backgroundColor: Colors.transparent,
                ),
              SvgPicture.asset(
                'assets/icon_svgs/icon_bookmark_outlined.svg',
                color: Colors.white,
              ),
            ],
          ),
          onPressed: () {
            cubit.savePost(
                userId: user!.uId,
                postId: postId,
                text: post.text!,
                image: post.image!,
                userPost: post.userId);
          },
        ),
      ],
    );
  }

  GestureDetector postImage(
    PostModel post,
    GroupsCubit cubit,
  ) {
    return GestureDetector(
      onTap: () {
        cubit.changeImageFit(post);
      },
      child: Container(
        width: post.fitting == BoxFit.contain ? null : 347,
        height: post.fitting == BoxFit.contain ? null : 193,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.5),
          borderRadius: BorderRadius.circular(4),
        ),
        child: CachedNetworkImage(
          imageUrl: post.image!,
          fit: post.fitting,
        ),
      ),
    );
  }

  Text postText(context, String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleSmall!.copyWith(
            color: const Color(0xff808080),
            fontWeight: FontWeight.w400,
          ),
    );
  }

  ListTile userInfo(context, UserModel user, postDate, PostModel post) {
    return ListTile(
      onTap: () {
        Navigator.pushNamed(
          context,
          userDetailsRoute,
          arguments: {
            'user': user,
            'heroId': post.postId,
          },
        );
      },
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        radius: 25,
        backgroundColor: Colors.grey.withOpacity(0.5),
        backgroundImage: CachedNetworkImageProvider(
          user.image,
        ),
      ),
      title: Text(
        user.name,
        style: Theme.of(context).textTheme.titleSmall!.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
      ),
      subtitle: Text(
        postDate,
        style: Theme.of(context).textTheme.titleSmall!.copyWith(
              height: 1.2,
              fontSize: 12,
              color: const Color(0xff808080),
              fontWeight: FontWeight.w400,
            ),
      ),
    );
  }
}
