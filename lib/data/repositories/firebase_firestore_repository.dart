import 'dart:io';

import 'package:book/data/models/book_model.dart';
import 'package:book/data/models/courses_model.dart';
import 'package:book/data/models/group_model.dart';
import 'package:book/data/web_services/firebase_firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseFirestoreRepository {
  final FirebaseFirestoreService _firebaseFirestoreService =
      FirebaseFirestoreService();

  Future createNewUser(
      {required String uId, required Map<String, dynamic> data}) async {
    var create = await _firebaseFirestoreService.firestoreCreateNewUser(
      uId: uId,
      data: data,
    );
    return create;
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>>? getUserInfo(
      {required String userID}) {
    var user = _firebaseFirestoreService.firestoreGetUserInfo(userID: userID);

    return user;
  }

  Future addFavoriteField(
      {required String userId, required String data}) async {
    return await _firebaseFirestoreService.firestoreAddFavoriteField(
      userId: userId,
      data: data,
    );
  }

  Future removeFavoriteField(
      {required String userId, required String data}) async {
    return await _firebaseFirestoreService.firestoreRemoveFavoriteField(
      userId: userId,
      data: data,
    );
  }

  Future<List<BookModel>?>? getBooks() async {
    List<BookModel> books = [];
    QuerySnapshot<Map<String, dynamic>>? bookCollection =
        await _firebaseFirestoreService.firestoreGetBooks();
    print(bookCollection!.docs[9].data()['bookName']);
    if (bookCollection != null) {
      for (var element in bookCollection.docs) {
        books.add(
          BookModel.fromJson(
            json: element.data(),
          ),
        );
      }
      return books;
    }
    return null;
  }

  Future<int?>? pushBookRate({
    required String bookId,
    required String comment,
    required double bookRate,
    required String userId,
  }) async {
    return await _firebaseFirestoreService.firestorePushBookRate(
      bookRate: bookRate,
      bookId: bookId,
      userId: userId,
      comment: comment,
    );
  }

  Future<Map<String, dynamic>?>? getBookRate({
    required String bookId,
  }) async {
    var reviewDocs = await _firebaseFirestoreService.firestoreGetBookRate(
      bookId: bookId,
    );
    if (reviewDocs != null) {
      List<BookReview> reviews = [];
      double totalRate = 0;
      for (var element in reviewDocs.docs) {
        totalRate += element.data()['bookRate'];
        reviews.add(
          BookReview.fromJson(json: element.data()),
        );
      }
      return {
        'reviews': reviews,
        'totalRate': totalRate,
      };
    }
    return null;
  }

  Future<void> createGroup({
    required String name,
    required List admins,
    required String? groupPhoto,
    required String createdBy,
    required String groupBio,
  }) async {
    return await _firebaseFirestoreService.firestoreCreateGroup(
      name: name,
      admins: admins,
      createdBy: createdBy,
      groupPhoto: groupPhoto,
      groupBio: groupBio,
    );
  }

  Future addBookMark({
    required String userId,
    required String bookId,
    required int pageNumber,
    required int allPageNumber,
    required String bookName,
  }) async {
    return await _firebaseFirestoreService.firestoreAddBookMark(
        userId: userId,
        bookId: bookId,
        pageNumber: pageNumber,
        allPageNumber: allPageNumber,
        bookName: bookName);
  }

  Future<List<CoursesModel>?>? getCourses() async {
    QuerySnapshot<Map<String, dynamic>>? docs =
        await _firebaseFirestoreService.firestoreGetCourses();
    List<CoursesModel> courses = [];
    if (docs != null) {
      for (var element in docs.docs) {
        courses.add(
          CoursesModel.fromJson(
            json: element.data(),
          ),
        );
      }
      return courses;
    }
    return null;
  }

  Future<List<GroupModel>?>? getAllGroups() async {
    var querySnapshot = await _firebaseFirestoreService.firestoreGetAllGroups();
    List<GroupModel> groups = [];
    if (querySnapshot != null) {
      for (var element in querySnapshot.docs) {
        groups.add(GroupModel.fromJson(data: element.data()));
      }
      return groups;
    }
    return null;
  }

  addToGroup({
    required String groupId,
    required String userId,
  }) async {
    await
    _firebaseFirestoreService.firestoreAddToGroup(
        groupId: groupId, userId: userId);
  }
}
