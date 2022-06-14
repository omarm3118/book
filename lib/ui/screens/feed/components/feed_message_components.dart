import 'package:book/constants/strings.dart';
import 'package:book/data/models/group_model.dart';
import 'package:book/ui/screens/my_groups/controller/groups_cubit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' as intl;

import '../../../../constants/colors.dart';
import '../../../../data/models/message_model.dart';
import '../../../../data/models/user_model.dart';
import '../../home/controller/layout_cubit.dart';

class FeedMessageComponents extends StatelessWidget {
  FeedMessageComponents({Key? key, required this.cubit, required this.group})
      : super(key: key);
  final GroupsCubit cubit;
  final TextEditingController textController = TextEditingController();
  final GroupModel group;
  final _formKey = GlobalKey<FormState>();
  String date = '';
  String time = '';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupsCubit, GroupsState>(builder: (context, state) {
      date = intl.DateFormat().add_yMMMd().format(DateTime.now());
      if (state is SendMessageSuccessState) {
        textController.clear();
        cubit.clearMessageImage();
      }
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (state is SendMessageLoadingState) LinearProgressIndicator(),
            Expanded(
              child: ListView.separated(
                  reverse: true,
                  shrinkWrap: true,
                  itemCount: cubit.messages.length,
                  separatorBuilder: (context, index) => SizedBox(
                        height: 30,
                      ),
                  itemBuilder: (context, index) {
                    bool isMe = cubit.messages[index].senderId ==
                        LayoutCubit.getUser!.uId;
                    return _messageItemBuilder(cubit.messages[index], isMe);
                  }),
            ),
            SizedBox(
              height: 10,
            ),
            if (cubit.messageImage.path != '')
              Expanded(
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
                          cubit.messageImage,
                        ),
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.white54,
                      foregroundColor: Colors.red,
                      child: IconButton(
                        icon: Icon(Icons.cancel_outlined),
                        onPressed: () {
                          cubit.clearMessageImage();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(defaultRadius),
                border: Border.all(
                  color: MyColors.defaultPurple,
                  width: 0.5,
                ),
              ),
              child: Row(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        primary: MyColors.defaultPurple,
                        maximumSize: Size(30, 30),
                        minimumSize: Size(30, 30),
                        padding: EdgeInsets.zero,
                        alignment: Alignment.center),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        cubit.sendMessage(
                          groupId: group.id!,
                          groupName: group.name!,
                          text: textController.text,
                        );
                      }
                    },
                    child: Icon(
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
                          controller: textController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'شارك المعلومات...',
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
                        cubit.imagePicker(isMessage: true);
                      },
                      child: const Icon(Icons.image_outlined),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  _messageItemBuilder(MessageModel messageModel, isMe) {
    var user = LayoutCubit.allUsers!.firstWhere(
      (UserModel element) => element.uId == messageModel.senderId,
      orElse: () => UserModel(
        email: 'email',
        name: 'UnKnown',
        uId: 'uId',
        isEmailVerified: false,
        phone: '',
        lastName: '',
      ),
    );
    Align align = Align(
      alignment: isMe
          ? AlignmentDirectional.centerStart
          : AlignmentDirectional.centerEnd,
      child: Container(
        margin: isMe ? EdgeInsets.only(left: 30) : EdgeInsets.only(right: 30),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            if (date != messageModel.date)
              Container(
                alignment: Alignment.center,
                child: Text(
                  messageModel.date.toString(),
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 9,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            if (time != messageModel.time)
              Container(
                alignment: Alignment.center,
                child: Text(
                  messageModel.time.toString(),
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 9,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            if (!isMe)
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                child: Text(
                  user.name.toString(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 9,
                  ),
                ),
              ),
            if (isMe)
              SizedBox(
                height: 10,
              ),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadiusDirectional.only(
                  bottomStart: !isMe ? Radius.circular(10) : Radius.zero,
                  topStart: Radius.circular(10),
                  topEnd: Radius.circular(10),
                  bottomEnd: isMe ? Radius.circular(10) : Radius.zero,
                ),
                color: isMe ? Colors.grey[300] : MyColors.defaultBackgroundPurple.withOpacity(0.4),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      messageModel.text,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  if (messageModel.image != '' && messageModel.image.isNotEmpty)
                    SizedBox(
                      height: 10,
                    ),
                  if (messageModel.image != '' && messageModel.image.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(2),
                      child: Card(
                        elevation: 5,
                        clipBehavior: Clip.antiAlias,
                        margin: EdgeInsets.zero,
                        child: CachedNetworkImage(
                          width: 250,
                          imageUrl: messageModel.image,
                          fit: BoxFit.cover,
                          alignment: Alignment.topRight,
                          errorWidget: (ctx, url, error) =>
                              Icon(Icons.error_outline),
                          placeholder: (ctx, url) => Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(8),
                              child: CircularProgressIndicator()),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (!isMe)
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(10, 3, 0, 0),
                child: CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(
                    user.image.toString(),
                  ),
                  radius: 9,
                ),
              ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
    if (time.toString() != messageModel.time.toString())
      time = messageModel.time!;
    if (date.toString() != messageModel.date.toString())
      date = messageModel.date.toString();
    return align;
  }
}
