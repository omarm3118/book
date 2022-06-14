import 'dart:io';

import 'package:book/data/models/book_model.dart';
import 'package:book/data/models/courses_model.dart';
import 'package:book/data/models/group_model.dart';
import 'package:book/data/models/user_model.dart';
import 'package:book/data/web_services/firebase_firestore_service.dart';
import 'package:book/ui/screens/home/controller/layout_cubit.dart';
import 'package:book/ui/widgets/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/post_model.dart';

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

  sendEmailVerification() {}

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

  Stream<QuerySnapshot<Map<String, dynamic>>>? getBookMark({
    required String userId,
  }) {
    return _firebaseFirestoreService.firestoreGetBookMark(userId: userId);
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
    await _firebaseFirestoreService.firestoreAddToGroup(
        groupId: groupId, userId: userId);
  }

  Future<String?>? firebaseCreateNewPost({
    required Map<String, dynamic> data,
    required String groupId,
  }) async {
    return await _firebaseFirestoreService.firestoreCreateNewPost(
      data: data,
      groupId: groupId,
    );
  }

  updateUserPosts({required String userId, required String postId}) async {
    await _firebaseFirestoreService.firestoreUpdateUserPosts(
      userId: userId,
      postId: postId,
    );
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? getGroupPosts({
    required String groupId,
  }) {
    return _firebaseFirestoreService.firestoreGetGroupPosts(groupId: groupId);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? getGroupPolls({
    required String groupId,
  }) {
    return _firebaseFirestoreService.firestoreGetGroupPolls(groupId: groupId);
  }

  Future<List<UserModel>?>? getAllUsers() async {
    var querySnapshot = await _firebaseFirestoreService.firestoreGetAllUsers();
    if (querySnapshot != null) {
      List<UserModel> users = [];
      for (var element in querySnapshot.docs) {
        users.add(
          UserModel.fromJson(
            element.data(),
          ),
        );
      }
      return users;
    }
    return null;
  }

  likePost({
    required String groupId,
    required String postId,
    required isLike,
    required userId,
  }) async {
    await _firebaseFirestoreService.firestoreLikePost(
      groupId: groupId,
      postId: postId,
      isLike: isLike,
      userId: userId,
    );
  }

  addComment(
      {required String groupId,
      required String postId,
      required Map<String, dynamic> data}) async {
    await _firebaseFirestoreService.firestoreAddComment(
        groupId: groupId, postId: postId, data: data);
  }

  Future<List<Comment>?>? getComments(
      {required String groupId, required String postId}) async {
    QuerySnapshot<Map<String, dynamic>>? querySnapshot =
        await _firebaseFirestoreService.firestoreGetComments(
            groupId: groupId, postId: postId);

    if (querySnapshot != null) {
      List<Comment> comments = [];
      for (var element in querySnapshot.docs) {
        comments.add(
          Comment.fromJson(json: element.data()),
        );
      }
      return comments;
    }
    return null;
  }

  updateUserBooks({required String userId, required String bookId}) async {
    await _firebaseFirestoreService.firestoreUpdateUserBooks(
        userId: userId, bookId: bookId);
  }

  updateUserTrack({
    required String userId,
    required String trackName,
    required int tracValue,
    String? secondTrackName,
    int? secondTrackValue,
  }) async {
    await _firebaseFirestoreService.firestoreUpdateUserTrack(
      userId: userId,
      trackName: trackName,
      tracValue: tracValue,
      secondTrackName: secondTrackName,
      secondTrackValue: secondTrackValue,
    );
  }

  savePost({
    required String userId,
    required String postId,
    required String text,
    required String image,
    required String userPost,
  }) async {
    await _firebaseFirestoreService.firestoreSavePost(
        userId: userId,
        postId: postId,
        text: text,
        image: image,
        userPost: userPost);
  }

  Future addLastBookToUserDashBoard({
    required String userId,
    required String bookId,
  }) async {
    return await _firebaseFirestoreService.firestoreAddLastBookToUserDashBoard(
        userId: userId, bookId: bookId);
  }

  Future<String?>? sendMessage({
    required Map<String, dynamic> data,
    required groupId,
  }) async {
    return await _firebaseFirestoreService.firestoreSendMessage(
      data: data,
      groupId: groupId,
    );
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? getGroupMessages({
    required String groupId,
  }) {
    return _firebaseFirestoreService.firestoreGetGroupMessages(
      groupId: groupId,
    );
  }

  Future<QuerySnapshot<Map<String, dynamic>>?>? getSavedPosts(
      {required String userId}) async {
    return await _firebaseFirestoreService.firestoreGetSavedPosts(
      userId: userId,
    );
  }

  Future updateUserInfo({
    required String name,
    required String bio,
    required String userId,
    String? coverImage,
    String? userImage,
  }) async {
    return await _firebaseFirestoreService.firestoreUpdateUserInfo(
      name: name,
      bio: bio,
      userId: userId,
      userImage: userImage,
      coverImage: coverImage,
    );
  }

  createPoll({
    required String groupId,
    required Map<String, dynamic> data,
  }) async {
    return await _firebaseFirestoreService.firestoreCreatePoll(
        groupId: groupId, data: data);
  }

  Future updatePoll({
    required String groupId,
    required String pollId,
    required int optionId,
    required String voterId,
  }) async {
    await
    _firebaseFirestoreService.firestoreUpdatePoll(
        groupId: groupId, pollId: pollId, optionId: optionId, voterId: voterId);
  }
}
