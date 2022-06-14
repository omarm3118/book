import 'package:book/data/models/group_model.dart';
import 'package:book/ui/widgets/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';

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

  Stream<QuerySnapshot<Map<String, dynamic>>>? firestoreGetBookMark({
    required String userId,
  }) {
    try {
      return _db
          .collection('users')
          .doc(userId)
          .collection('bookMarks')
          .snapshots();
    } catch (e) {
      showingToast(msg: e.toString(), state: ToastState.error);
    }
    return null;
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

  Future<String?>? firestoreCreateNewPost({
    required Map<String, dynamic> data,
    required groupId,
  }) async {
    try {
      var documentReference =
          _db.collection('posts').doc(groupId).collection('groupPosts').doc();
      await documentReference.set({
        ...data,
        'postId': documentReference.id,
      });
      return documentReference.id;
    } catch (e) {
      showingToast(msg: e.toString(), state: ToastState.error);
    }
    return null;
  }

  firestoreUpdateUserPosts(
      {required String userId, required String postId}) async {
    try {
      await _db.collection('users').doc(userId).update({
        'posts': FieldValue.arrayUnion(
          [postId],
        ),
      });
    } catch (e) {
      showingToast(msg: e.toString(), state: ToastState.error);
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? firestoreGetGroupPosts(
      {required String groupId}) {
    try {
      return _db
          .collection('posts/$groupId/groupPosts')
          .orderBy('dateTime', descending: true)
          .snapshots();
    } catch (e) {
      showingToast(
        msg: e.toString(),
        state: ToastState.error,
      );
    }
    return null;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? firestoreGetGroupPolls(
      {required String groupId}) {
    try {
      return _db
          .collection('posts/$groupId/groupPolls')
          .orderBy('dateTime', descending: true)
          .snapshots();
    } catch (e) {
      showingToast(
        msg: e.toString(),
        state: ToastState.error,
      );
    }
    return null;
  }

  Future<QuerySnapshot<Map<String, dynamic>>?>? firestoreGetAllUsers() async {
    try {
      return await _db.collection('users').get();
    } catch (e) {
      showingToast(msg: e.toString(), state: ToastState.error);
    }
    return null;
  }

  firestoreLikePost({
    required String groupId,
    required String postId,
    required isLike,
    required String userId,
  }) async {
    try {
      await _db.collection('posts/$groupId/groupPosts').doc(postId).update(
            isLike
                ? {
                    'likes': FieldValue.arrayRemove([userId])
                  }
                : {
                    'likes': FieldValue.arrayUnion([userId])
                  },
          );
    } catch (e) {
      showingToast(msg: e.toString(), state: ToastState.error);
    }
  }

  Future firestoreAddComment(
      {required String groupId,
      required String postId,
      required Map<String, dynamic> data}) async {
    try {
      var collectionReference = _db
          .collection('posts/$groupId/groupPosts/')
          .doc(postId)
          .collection('comments')
          .doc();
      return await collectionReference.set({
        ...data,
        'commentId': collectionReference.id,
      });
    } catch (e) {
      showingToast(msg: e.toString(), state: ToastState.error);
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>?>? firestoreGetComments(
      {required String groupId, required String postId}) async {
    try {
      return await _db
          .collection('posts/$groupId/groupPosts')
          .doc(postId)
          .collection('comments')
          .get();
    } catch (e) {
      showingToast(msg: e.toString(), state: ToastState.error);
    }
    return null;
  }

  Future firestoreUpdateUserBooks(
      {required String userId, required String bookId}) async {
    try {
      return await _db.collection('users').doc(userId).update({
        'books': FieldValue.arrayUnion([bookId])
      });
    } catch (e) {
      showingToast(msg: e.toString(), state: ToastState.error);
    }
  }

  firestoreSavePost({
    required String userId,
    required String postId,
    required String text,
    required String image,
    required String userPost,
  }) async {
    try {
      await _db
          .collection('users')
          .doc(userId)
          .collection('savedPosts')
          .doc(postId)
          .set(
        {
          'userPost': userPost,
          'text': text,
          'image': image,
          'postId': postId,
        },
      );
    } catch (e) {
      showingToast(msg: e.toString(), state: ToastState.error);
    }
  }

  Future firestoreUpdateUserTrack({
    required String userId,
    required String trackName,
    required int tracValue,
    String? secondTrackName,
    int? secondTrackValue,
  }) async {
    try {
      return await _db.collection('users').doc(userId).update(
        {
          trackName: tracValue,
          if (secondTrackName != null && secondTrackValue != null)
            secondTrackName: secondTrackValue,
        },
      );
    } catch (e) {
      showingToast(msg: e.toString(), state: ToastState.error);
    }
  }

  Future firestoreAddLastBookToUserDashBoard(
      {required String userId, required String bookId}) async {
    try {
      return await _db.collection('users').doc(userId).update(
        {'lastOpenBook': bookId},
      );
    } catch (e) {
      showingToast(msg: e.toString(), state: ToastState.error);
    }
  }

  Future<String?>? firestoreSendMessage({
    required Map<String, dynamic> data,
    required groupId,
  }) async {
    try {
      var documentReference = _db
          .collection('messages')
          .doc(groupId)
          .collection('groupMessages')
          .doc();
      await documentReference.set({
        ...data,
        'postId': documentReference.id,
      });
      return documentReference.id;
    } catch (e) {
      showingToast(msg: e.toString(), state: ToastState.error);
    }
    return null;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? firestoreGetGroupMessages(
      {required String groupId}) {
    try {
      return _db
          .collection('messages/$groupId/groupMessages')
          .orderBy('dateTime', descending: true)
          .snapshots();
    } catch (e) {
      showingToast(
        msg: e.toString(),
        state: ToastState.error,
      );
    }
    return null;
  }

  Future<QuerySnapshot<Map<String, dynamic>>?>? firestoreGetSavedPosts(
      {required String userId}) async {
    try {
      return await _db
          .collection('users')
          .doc(userId)
          .collection('savedPosts')
          .get();
    } catch (e) {
      showingToast(msg: e.toString(), state: ToastState.error);
    }
    return null;
  }

  Future firestoreUpdateUserInfo({
    required String name,
    required String bio,
    required String userId,
    String? coverImage,
    String? userImage,
  }) async {
    try {
      return await _db.collection('users').doc(userId).update({
        'name': name,
        'bio': bio,
        if (userImage != null) 'image': userImage,
        if (coverImage != null) 'cover': coverImage,
      });
    } catch (e) {
      showingToast(msg: e.toString(), state: ToastState.error);
    }
  }

  Future firestoreCreatePoll({
    required String groupId,
    required Map<String, dynamic> data,
  }) async {
    try {
      DocumentReference<Map<String, dynamic>> docRef = await _db
          .collection('posts')
          .doc(groupId)
          .collection('groupPolls')
          .doc();
      return await docRef.set({
        ...data,
        'pollId': docRef.id,
      });
    } catch (e) {
      showingToast(msg: e.toString(), state: ToastState.error);
    }
  }

  Future firestoreUpdatePoll({
    required String groupId,
    required String pollId,
    required int optionId,
    required String voterId,
  }) async {
    try {
      await _db
          .collection('posts')
          .doc(groupId)
          .collection('groupPolls')
          .doc(pollId)
          .update({
        'whoVoted': FieldValue.arrayUnion([
          {'voterId': voterId, 'optionId': optionId}
        ])
      });
    } catch (e) {
      showingToast(msg: e.toString(), state: ToastState.error);
    }
  }
}
