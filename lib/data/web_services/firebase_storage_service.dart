import 'dart:io';

import 'package:book/ui/widgets/toast.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  final storage = FirebaseStorage.instance;

  Future<String?>? firebaseUploadGroupPhoto(
      {required File groupImage, required groupName}) async {
    try {
      TaskSnapshot ref =
          await storage.ref('groupImage').child(groupName).putFile(groupImage);
      return await ref.ref.getDownloadURL();
    } catch (e) {
      showingToast(msg: e.toString(), state: ToastState.error);
    }
    return null;
  }

  firebaseUploadPostPhoto({required File postImage, required groupName}) async {
    try {
      TaskSnapshot ref = await storage
          .ref('postImage/$groupName')
          .child(
            Uri.file(postImage.path).pathSegments.last,
          )
          .putFile(postImage);
      return await ref.ref.getDownloadURL();
    } catch (e) {
      showingToast(msg: e.toString(), state: ToastState.error);
    }
    return null;
  }

  firebaseUploadMessagePhoto(
      {required File messageImage, required groupName}) async {
    try {
      TaskSnapshot ref = await storage
          .ref('messageImage/$groupName')
          .child(
            Uri.file(messageImage.path).pathSegments.last,
          )
          .putFile(messageImage);
      return await ref.ref.getDownloadURL();
    } catch (e) {
      showingToast(msg: e.toString(), state: ToastState.error);
    }
    return null;
  }

  firebaseUploadUserImage(
      {required File userImage, required String userId}) async {
    try {
      TaskSnapshot ref =
          await storage.ref('userImage').child(userId).putFile(userImage);
      return await ref.ref.getDownloadURL();
    } catch (e) {
      showingToast(msg: e.toString(), state: ToastState.error);
    }
    return null;
  }

  firebaseUploadUserPhoto({required File userImage, required userid}) async {
    try {
      TaskSnapshot ref = await storage
          .ref('userImage/$userid')
          .child(
            'profile',
          )
          .putFile(userImage);
      return await ref.ref.getDownloadURL();
    } catch (e) {
      showingToast(msg: e.toString(), state: ToastState.error);
    }
    return null;
  }

  firebaseUploadCoverPhoto({required File coverImage, required userid}) async {
    try {
      TaskSnapshot ref = await storage
          .ref('userImage/$userid')
          .child(
            'cover',
          )
          .putFile(coverImage);
      return await ref.ref.getDownloadURL();
    } catch (e) {
      showingToast(msg: e.toString(), state: ToastState.error);
    }
    return null;
  }
}
