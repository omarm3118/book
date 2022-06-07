import 'package:book/data/models/group_model.dart';
import 'package:book/ui/widgets/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseFirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future firestoreCreateNewUser(
      {required String uId, required Map<String, dynamic> data}) async {
    try {
      return await _db.collection('users').doc(uId).set(data);
    } catch (e) {
      showingToast(msg: e.toString(), state: ToastState.error);
      return 1;
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>>? firestoreGetUserInfo(
      {required String userID}) {
    try {
      return _db.collection('users').doc(userID).snapshots();
    } catch (e) {
      showingToast(msg: e.toString(), state: ToastState.error);
    }
    return null;
  }

  Future<QuerySnapshot<Map<String, dynamic>>?>? firestoreGetBooks() async {
    try {
      return await _db.collection('books').get();
    } catch (e) {
      showingToast(
        msg: e.toString(),
        state: ToastState.error,
      );
    }
    return null;
  }

  Future firestoreAddFavoriteField({
    required String userId,
    required String data,
  }) async {
    try {
      return await _db.collection('users').doc(userId).update(
        {
          'favoriteFields': FieldValue.arrayUnion([data])
        },
      );
    } catch (e) {
      showingToast(msg: e.toString(), state: ToastState.error);
      return 1;
    }
  }

  Future firestoreRemoveFavoriteField({
    required String userId,
    required String data,
  }) async {
    try {
      return await _db.collection('users').doc(userId).update(
        {
          'favoriteFields': FieldValue.arrayRemove([data])
        },
      );
    } catch (e) {
      showingToast(msg: e.toString(), state: ToastState.error);
      return 1;
    }
  }

  Future<int?>? firestorePushBookRate({
    required double bookRate,
    required String comment,
    required String bookId,
    required String userId,
  }) async {
    try {
      await _db
          .collection('books')
          .doc(bookId)
          .collection('reviews')
          .doc(userId)
          .set(
        {
          'userId': userId,
          'bookRate': bookRate,
          'comment': comment,
          'date': FieldValue.serverTimestamp(),
        },
      );

      return 1;
    } catch (e) {
      showingToast(
        msg: e.toString(),
        state: ToastState.error,
      );
    }
    return null;
  }

  Future<QuerySnapshot<Map<String, dynamic>>?>? firestoreGetBookRate({
    required String bookId,
  }) async {
    try {
      return await _db
          .collection('books')
          .doc(bookId)
          .collection('reviews')
          .get();
    } catch (e) {
      showingToast(
        msg: e.toString(),
        state: ToastState.error,
      );
    }
    return null;
  }

  Future<void> firestoreCreateGroup({
    required String name,
    required List admins,
    required String createdBy,
    required String? groupPhoto,
    required String groupBio,
  }) async {
    try {
      var doc = _db.collection('groups').doc();
      GroupModel data = groupPhoto != null
          ? GroupModel(
              groupImage: groupPhoto,
              name: name,
              admins: admins,
              createdBy: createdBy,
              id: doc.id,
              groupBio: groupBio,
              members: [admins[0]],
            )
          : GroupModel(
              name: name,
              admins: admins,
              createdBy: createdBy,
              id: doc.id,
              groupBio: groupBio,
              members: [admins[0]],
            );
      await doc.set(data.toJson());
      await _db.collection('users').doc(createdBy).update({
        'groups': FieldValue.arrayUnion([doc.id])
      });
    } catch (e) {
      showingToast(msg: e.toString(), state: ToastState.error);
    }
    return;
  }

  Future firestoreAddBookMark({
    required String userId,
    required String bookId,
    required int pageNumber,
    required int allPageNumber,
    required String bookName,
  }) async {
    try {
      return await _db
          .collection('users')
          .doc(userId)
          .collection('bookMarks')
          .doc(bookId)
          .set(
        {
          'bookName': bookName,
          'pageNumber': pageNumber,
          'allPageNumber': allPageNumber,
          'bookId': bookId,
        },
        SetOptions(merge: true),
      );
    } catch (e) {
      showingToast(msg: e.toString(), state: ToastState.error);
    }
    return 1;
  }

  Future<QuerySnapshot<Map<String, dynamic>>?>? firestoreGetCourses() async {
    try {
      return await _db.collection('courses').get();
    } catch (e) {
      showingToast(msg: e.toString(), state: ToastState.error);
    }
    return null;
  }

  Future<QuerySnapshot<Map<String, dynamic>>?>? firestoreGetAllGroups() async {
    try {
      return await _db.collection('groups').get();
    } catch (e) {
      showingToast(msg: e.toString(), state: ToastState.error);
    }
    return null;
  }

  Future firestoreAddToGroup({
    required String groupId,
    required String userId,
  }) async {
    try {
      await _db.collection('groups').doc(groupId).update(
        {
          'members': FieldValue.arrayUnion([userId])
        },
      );
      await _db.collection('users').doc(userId).update({
        'groups': FieldValue.arrayUnion([groupId])
      });
    } catch (e) {
      showingToast(msg: e.toString(), state: ToastState.error);
    }
  }
}
