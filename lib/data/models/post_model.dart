import 'package:book/ui/screens/home/controller/layout_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PostModel {
  late String postId;
  late String userId;
  String? image;
  String? text;
  late String dateTime;
  late List likes = [];
  late bool isLike = false;
  List<Comment> comments = [];
  BoxFit fitting=BoxFit.cover;

  PostModel({
    required this.userId,
    required this.image,
    required this.text,
  });

  PostModel.fromJson({
    required Map<String, dynamic> json,
  }) {
    DateFormat formatting = DateFormat().add_yMMMd().add_jm();

    postId = json['postId'];
    userId = json['userId'];
    image = json['image'];
    text = json['text'];
    likes = json['likes'];
    dateTime = formatting.format(json['dateTime'].toDate());
    isLike = json['likes'].contains(
      LayoutCubit.getUser!.uId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'image': image,
      'text': text,
      'dateTime': FieldValue.serverTimestamp(),
      'likes': likes,
    };
  }
}

class Comment {
  String? userId;
  String? comment;
  String? commentId;
  String? date;

  Comment.fromJson({required Map<String, dynamic> json}) {
    DateFormat formatting = DateFormat().add_yMd();
    userId = json['userId'];
    comment = json['comment'];
    commentId = json['commentId'];
    date = formatting.format(json['dateTime'].toDate());
  }
}
