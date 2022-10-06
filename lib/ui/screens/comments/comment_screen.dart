import 'package:book/constants/colors.dart';
import 'package:book/constants/strings.dart';
import 'package:book/data/models/post_model.dart';
import 'package:book/ui/screens/my_groups/controller/groups_cubit.dart';
import 'package:book/ui/widgets/conditional_builder.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/user_model.dart';
import '../home/controller/layout_cubit.dart';

class CommentScreen extends StatelessWidget {
  CommentScreen(
      {Key? key,
      required this.post,
      required this.groupId,
      required this.userId})
      : super(key: key);
  PostModel post;
  final String groupId;
  final String userId;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    GroupsCubit cubit = BlocProvider.of<GroupsCubit>(context);

    onInit(cubit);
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<GroupsCubit, GroupsState>(
          builder: (context, state) {
            if (state is AddCommentSuccessState) {
              _textController.clear();
            }
            return Column(
              children: [
                if (state is AddCommentLoadingState ||
                    state is GetCommentLoadingState)
                  const LinearProgressIndicator(),
                Expanded(
                  flex: 9,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(24),
                    itemBuilder: (BuildContext _, int index) =>
                        commentItem(context, post.comments[index]),
                    itemCount: post.comments.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(
                      height: 20,
                      color: MyColors.defaultPurple.withOpacity(0.1),
                    ),
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        primary: MyColors.defaultPurple,
                        maximumSize: Size(30, 30),
                        minimumSize: Size(30, 30),
                        padding: EdgeInsets.zero,
                        alignment: Alignment.center,
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          cubit.addComment(
                            groupId: groupId,
                            postId: post.postId,
                            userId: userId,
                            comment: _textController.text,
                          );
                        }
                      },
                      child: const Icon(
                        Icons.send_outlined,
                        color: Colors.white,
                        size: 17,
                        textDirection: TextDirection.ltr,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Form(
                          key: _formKey,
                          child: TextFormField(
                            validator: (String? value) {
                              if (value!.isEmpty) return "أكتب شيئًا...";
                              return null;
                            },
                            controller: _textController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'أرسل تعلقيك ليصل إلى العالم...',
                            ),
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: TextButton(
                        onPressed: () {
                          cubit.imagePicker(isComment: true);
                        },
                        child: const Icon(Icons.image_outlined),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  commentItem(BuildContext context, Comment comment) {
    return ConditionalBuilder(
      successWidget: (_) {
        UserModel user = LayoutCubit.allUsers!
            .firstWhere((element) => element.uId == comment.userId);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      userDetailsRoute,
                      arguments: {'user': user, 'heroId': comment.commentId},
                    );
                  },
                  child: Hero(
                    tag: comment.commentId!,
                    child: Container(
                      width: 40,
                      height: 40,
                      clipBehavior: Clip.antiAlias,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xffD1CDE9),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: user.image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 6,
                ),
                Text(
                  user.name,
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(
                  width: 3,
                ),
                Text(
                  comment.date.toString(),
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        height: 1.2,
                        fontSize: 12,
                        color: const Color(0xff808080),
                        fontWeight: FontWeight.w400,
                      ),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.start,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              comment.comment.toString(),
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: const Color(0xff808080),
                    fontWeight: FontWeight.w400,
                  ),
            ),
          ],
        );
      },
      condition: LayoutCubit.allUsers != null,
      fallbackWidget: (BuildContext) => Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Future onInit(GroupsCubit cubit) async {
    await cubit.getComment(
      groupId: groupId,
      postId: post.postId,
    );
  }
}
