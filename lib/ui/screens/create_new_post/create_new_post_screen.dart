import 'package:book/data/models/group_model.dart';
import 'package:book/data/models/user_model.dart';
import 'package:book/ui/screens/my_groups/controller/groups_cubit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../home/controller/layout_cubit.dart';

class CreateNewPost extends StatelessWidget {
  CreateNewPost({Key? key, required this.group}) : super(key: key);
  TextEditingController textController = TextEditingController();
  final GroupModel group;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GroupsCubit, GroupsState>(
      listener: (context, state) {
        if (state is CreatePostSuccessState) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        GroupsCubit cubit = BlocProvider.of<GroupsCubit>(context);
        UserModel? user = LayoutCubit.getUser;
        return Scaffold(
          appBar: AppBar(
            title: appBarTitle(),
            actions: [
              postButton(cubit),
              const SizedBox(
                width: 5,
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: LayoutBuilder(
              builder: (context, BoxConstraints constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(maxHeight: constraints.maxHeight),
                    child: Column(
                      children: [
                        if (state is CreatePostLoadingState)
                          const LinearProgressIndicator(),
                        const SizedBox(
                          height: 10,
                        ),
                        userInfo(user, context),
                        textField(),
                        if (cubit.postPickedImage.path != '') image(cubit),
                        addPhotoButton(cubit),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Align addPhotoButton(GroupsCubit cubit) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: () {
                cubit.imagePicker(isPost: true);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.image),
                  SizedBox(
                    width: 5,
                  ),
                  Text('أضف صورة'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Expanded image(GroupsCubit cubit) {
    return Expanded(
      flex: 2,
      child: Stack(
        alignment: AlignmentDirectional.topEnd,
        children: [
          Card(
            elevation: 2,
            child: Image(
              height: 300,
              width: double.infinity,
              image: FileImage(
                cubit.postPickedImage,
              ),
            ),
          ),
          CircleAvatar(
            backgroundColor: Colors.white54,
            foregroundColor: Colors.red,
            child: IconButton(
              icon: const Icon(Icons.cancel_outlined),
              onPressed: () {
                cubit.clearPostImage();
              },
            ),
          ),
        ],
      ),
    );
  }

  Expanded textField() {
    return Expanded(
      child: TextFormField(
        maxLines: 5,
        controller: textController,
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: "اكتب أفكارك...",
        ),
      ),
    );
  }

  ListTile userInfo(UserModel? user, BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
          radius: 25,
          backgroundColor: Colors.white,
          backgroundImage: CachedNetworkImageProvider(
            user!.image,
          )),
      title: Text(
        user.name,
        style: Theme.of(context).textTheme.subtitle2,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      contentPadding: EdgeInsets.zero,
    );
  }

  TextButton postButton(GroupsCubit cubit) {
    return TextButton(
      onPressed: () {
        cubit.createNewPost(
          text: textController.text,
          group: group,
        );
        textController.clear();
      },
      child: const Text('نشر'),
    );
  }

  Text appBarTitle() => const Text('عبّر بإبداع');
}
