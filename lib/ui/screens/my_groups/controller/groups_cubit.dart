import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:book/data/models/group_model.dart';
import 'package:book/data/models/message_model.dart';
import 'package:book/data/models/poll_model.dart';
import 'package:book/data/models/post_model.dart';
import 'package:book/data/models/user_model.dart';
import 'package:book/data/repositories/firebase_storage_repository.dart';
import 'package:book/ui/screens/home/controller/layout_cubit.dart';
import 'package:book/ui/widgets/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

import '../../../../data/repositories/firebase_firestore_repository.dart';

part 'groups_state.dart';

class GroupsCubit extends Cubit<GroupsState> {
  GroupsCubit(
      {required this.firebaseStorageRepository,
      required this.firebaseFirestoreRepository})
      : super(GroupsInitial());
  final FirebaseFirestoreRepository firebaseFirestoreRepository;
  final FirebaseStorageRepository firebaseStorageRepository;
  File groupImage = File('');
  File postPickedImage = File('');
  File commentImage = File('');
  File messageImage = File('');

  List<GroupModel> groups = [];
  List<GroupModel> myGroups = [];

  changeImageFit(PostModel post) {
    post.fitting =
        post.fitting == BoxFit.contain ? BoxFit.cover : BoxFit.contain;

    emit(ChangeImageFitState());
  }

  Future<void> imagePicker({
    bool isPost = false,
    bool isComment = false,
    bool isMessage = false,
  }) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker
        .pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
      maxHeight: 600,
      imageQuality: 75,
    )
        .then((XFile? value) {
      if (value != null) {
        if (isPost) {
          postPickedImage = File(value.path);
        } else if (isComment) {
          commentImage = File(value.path);
        } else if (isMessage) {
          messageImage = File(value.path);
        } else {
          groupImage = File(value.path);
        }
      }
      emit(ImagePickerSuccess());
    }).catchError((e) {
      emit(ImagePickerError());
      showingToast(
        msg: e.toString(),
        state: ToastState.error,
      );
    });
  }

  clearGroupImage() {
    emit(ClearImage());
    groupImage = File('');
  }

  clearMessageImage() {
    emit(ClearImage());
    messageImage = File('');
  }

  clearPostImage() {
    emit(ClearImage());
    postPickedImage = File('');
  }

  createGroup({
    required UserModel user,
    required String groupName,
    String? groupPhoto,
    required String groupBio,
  }) async {
    if (groupImage.path != '') {
      groupPhoto = await _uploadGroupPhoto(
        groupImage,
        groupName,
      );
    }
    emit(CreateGroupLoadingState());

    try {
      await firebaseFirestoreRepository.createGroup(
        name: groupName,
        admins: [user.uId],
        createdBy: user.uId,
        groupPhoto: groupPhoto,
        groupBio: groupBio,
      );
      emit(CreateGroupSuccessState());
    } catch (e) {
      emit(CreateGroupErrorState());
    }
  }

  Future<String?>? _uploadGroupPhoto(File groupPhoto, groupName) async {
    try {
      return await firebaseStorageRepository.uploadGroupPhoto(
          groupImage: groupImage, groupName: groupName);
    } catch (e) {
      showingToast(msg: e.toString(), state: ToastState.error);
    }
    return null;
  }

  getAllGroups() async {
    emit(GetGroupsLoadingState());
    List<GroupModel>? checkGroups =
        await firebaseFirestoreRepository.getAllGroups();
    if (checkGroups != null) {
      groups = checkGroups;
      myGroups = groups.where(
        (element) {
          if (LayoutCubit.getUser!.groups.contains(
                element.id,
              ) &&
              element.members!.contains(
                LayoutCubit.getUser!.uId,
              )) {
            element.inIt = true;
            return true;
          }
          return false;
        },
      ).toList();
      emit(GetGroupsSuccessState());
    } else {
      emit(GetGroupsErrorState());
    }
  }

  addToGroup({
    required String groupId,
    required String userId,
  }) async {
    emit(AddToGroupLoadingState());
    try {
      await firebaseFirestoreRepository.addToGroup(
          groupId: groupId, userId: userId);
      emit(AddToGroupSuccessState());
    } catch (e) {
      emit(AddToGroupErrorState());
    }
  }

  Future<void> createNewPost({
    required String text,
    required GroupModel group,
  }) async {
    UserModel? user = LayoutCubit.getUser;
    PostModel postModel = PostModel(
      text: text,
      userId: user!.uId,
      image: '',
    );
    emit(CreatePostLoadingState());
    try {
      if (postPickedImage.path != '') {
        postModel.image = await _uploadPostImage(
          postPickedImage,
          group.name,
        );
      }
      String? postId = await firebaseFirestoreRepository.firebaseCreateNewPost(
        data: postModel.toJson(),
        groupId: group.id!,
      );
      await _updateUserPostNumber(postId!, user.uId);
      postPickedImage = File('');
      emit(CreatePostSuccessState());
    } catch (e) {
      showingToast(
        msg: e.toString(),
        state: ToastState.error,
      );
      emit(CreatePostErrorState());
    }
  }

  Future<String?>? _uploadPostImage(File postImage, groupName) async {
    try {
      return await firebaseStorageRepository.uploadPostPhoto(
        postImage: postImage,
        groupName: groupName,
      );
    } catch (e) {
      showingToast(msg: e.toString(), state: ToastState.error);
    }
    return null;
  }

  Future<String?>? _uploadMessageImage(File messageImage, groupName) async {
    try {
      return await firebaseStorageRepository.uploadMessagePhoto(
        messageImage: messageImage,
        groupName: groupName,
      );
    } catch (e) {
      showingToast(msg: e.toString(), state: ToastState.error);
    }
    return null;
  }

  _updateUserPostNumber(String postId, String userId) {
    firebaseFirestoreRepository.updateUserPosts(userId: userId, postId: postId);
  }

  List<PostModel> posts = [];
  List<PollModel> polls = [];

  getGroupPosts({required String groupId}) {
    posts.clear();
    emit(GetPostsLoadingState());
    firebaseFirestoreRepository.getGroupPosts(groupId: groupId)!.listen(
      (event) {
        posts.clear();
        for (var element in event.docs) {
          posts.add(
            PostModel.fromJson(
              json: element.data(),
            ),
          );
        }
        emit(GetPostsSuccessState());
      },
    ).onError((e) {
      emit(GetPostsErrorState());
      showingToast(msg: e.toString(), state: ToastState.error);
    });
  }

  likePost({
    required String groupId,
    required String postId,
    required isLike,
    required userId,
  }) async {
    await firebaseFirestoreRepository.likePost(
      groupId: groupId,
      postId: postId,
      isLike: isLike,
      userId: userId,
    );
    emit(LikePostSuccessState());
  }

  addComment({
    required String groupId,
    required String postId,
    required userId,
    required comment,
  }) async {
    Map<String, dynamic> data = {
      'comment': comment,
      'dateTime': FieldValue.serverTimestamp(),
      'userId': userId,
    };
    emit(AddCommentLoadingState());
    await firebaseFirestoreRepository.addComment(
        groupId: groupId, postId: postId, data: data);
    await getComment(groupId: groupId, postId: postId);
    emit(AddCommentSuccessState());
  }

  Future<PostModel?> getComment(
      {required String groupId, required String postId}) async {
    emit(GetCommentLoadingState());

    List<Comment>? list = await firebaseFirestoreRepository.getComments(
      groupId: groupId,
      postId: postId,
    );
    if (list != null) {
      // fill comments for the post
      PostModel post = posts.firstWhere((element) {
        if (element.postId == postId) {
          element.comments = list;
          return true;
        }
        return false;
      });
      emit(GetCommentSuccessState());

      return post;
    }
    return null;
  }

  sendMessage({
    required String text,
    required String groupId,
    required String groupName,
  }) async {
    emit(SendMessageLoadingState());
    try {
      MessageModel messageModel = MessageModel(
        receiverId: groupId,
        text: text,
        senderId: LayoutCubit.getUser!.uId,
        image: '',
      );

      if (messageImage.path != '') {
        messageModel.image = await _uploadMessageImage(
              messageImage,
              groupName,
            ) ??
            '';
      }
      await firebaseFirestoreRepository.sendMessage(
        data: messageModel.toJson(),
        groupId: groupId,
      );
      emit(SendMessageSuccessState());
      messageImage = File('');
    } catch (e) {
      messageImage = File('');
      showingToast(msg: e.toString(), state: ToastState.error);
      emit(SendMessageErrorState());
    }
  }

  List<MessageModel> messages = [];

  getMessages({required String groupId}) {
    messages.clear();
    emit(GetMessagesLoadingState());
    firebaseFirestoreRepository.getGroupMessages(groupId: groupId)!.listen(
      (event) {
        messages.clear();
        for (var element in event.docs) {
          messages.add(
            MessageModel.fromJson(
              json: element.data(),
            ),
          );
        }
        emit(GetMessagesSuccessState());
      },
    ).onError((e) {
      emit(GetMessagesErrorState());
      showingToast(msg: e.toString(), state: ToastState.error);
    });
  }

  savePost({
    required userId,
    required postId,
    required String text,
    required String image,
    required String userPost,
  }) async {
    emit(SavePostLoadingState(postId: postId));
    await firebaseFirestoreRepository.savePost(
        userId: userId,
        postId: postId,
        text: text,
        image: image,
        userPost: userPost);
    emit(SavePostSuccessState());
  }

  openSearch(context) {
    emit(Searching());
  }

  createPoll({
    required String creatorId,
    required String groupId,
    required String question,
    required List<Option> options,
  }) async {
    try {
      emit(CreatePollLoadingState());
      var poll = PollModel(
        question: question,
        options: options,
        creatorId: creatorId,
      );
      await firebaseFirestoreRepository.createPoll(
        groupId: groupId,
        data: poll.toJson(),
      );
      emit(CreatePollSuccessState());
    } catch (e) {
      emit(CreatePollErrorState());
      showingToast(msg: e.toString(), state: ToastState.error);
    }
  }

  getGroupPolls({required String groupId}) {
    polls.clear();
    emit(GetPollsLoadingState());
    firebaseFirestoreRepository.getGroupPolls(groupId: groupId)!.listen(
      (event) {
        polls.clear();
        for (var element in event.docs) {
          polls.add(
            PollModel.fromJson(
              json: element.data(),
            ),
          );
        }
        emit(GetPollsSuccessState());
      },
    ).onError((e) {
      emit(GetPollsErrorState());
      showingToast(msg: e.toString(), state: ToastState.error);
    });
  }

  Future updatePoll({
    required String groupId,
    required String pollId,
    required int optionId,
    required String voterId,
  }) async {
    await firebaseFirestoreRepository.updatePoll(
      groupId: groupId,
      pollId: pollId,
      optionId: optionId,
      voterId: voterId,
    );
  }
}
