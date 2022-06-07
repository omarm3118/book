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
}
