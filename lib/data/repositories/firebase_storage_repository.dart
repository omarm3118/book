import 'dart:io';

import 'package:book/data/web_services/firebase_storage_service.dart';

class FirebaseStorageRepository {
  final FirebaseStorageService _firebaseStorageService =
      FirebaseStorageService();

  Future<String?>? uploadGroupPhoto(
      {required File groupImage, required String groupName}) async {
    return await _firebaseStorageService.firebaseUploadGroupPhoto(
        groupImage: groupImage, groupName: groupName);
  }

  Future<String?>? uploadPostPhoto(
      {required File postImage, required String groupName}) async {
    return await _firebaseStorageService.firebaseUploadPostPhoto(
      postImage: postImage,
      groupName: groupName,
    );
  }
  Future<String?>? uploadMessagePhoto(
      {required File messageImage, required String groupName}) async {
    return await _firebaseStorageService.firebaseUploadMessagePhoto(
      messageImage: messageImage,
      groupName: groupName,
    );
  }
  Future<String?>? uploadUserPhoto(
      {required File userImage, required String userId}) async {
    return await _firebaseStorageService.firebaseUploadUserPhoto(
      userImage: userImage,
      userid: userId,
    );
  }
  Future<String?>? uploadCoverPhoto(
      {required File coverImage, required String userId}) async {
    return await _firebaseStorageService.firebaseUploadCoverPhoto(
      coverImage: coverImage,
      userid: userId,
    );
  }


}
