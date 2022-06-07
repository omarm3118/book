import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:book/data/models/group_model.dart';
import 'package:book/data/models/user_model.dart';
import 'package:book/data/repositories/firebase_storage_repository.dart';
import 'package:book/ui/screens/home/controller/layout_cubit.dart';
import 'package:book/ui/widgets/toast.dart';
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
  List<GroupModel> groups = [];
  List<GroupModel> myGroups = [];

  Future<void> imagePicker() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker
        .pickImage(source: ImageSource.gallery)
        .then((XFile? value) {
      if (value != null) {
        groupImage = File(value.path);
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

  _uploadGroupPhoto(File groupPhoto, groupName) {
    try {
      firebaseStorageRepository.uploadGroupPhoto(
          groupImage: groupImage, groupName: groupName);
    } catch (e) {
      showingToast(msg: e.toString(), state: ToastState.error);
    }
  }

  getAllGroups() async {
    emit(GetGroupsLoadingState());
    List<GroupModel>? checkGroups =
        await firebaseFirestoreRepository.getAllGroups();
    if (checkGroups != null) {
      groups = checkGroups;
      myGroups = groups.where(
        (element) {
          if (LayoutCubit.getUser!.groups.contains(element.id)) {
            element.inIt=true;
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
}
