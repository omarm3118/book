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
}
