import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel{
  late String postId;
  late String userId;
   String? image;
   String? text;
  late String dateTime;
  late List likes=[];
  late bool isLike=false;

  PostModel({
    required this.postId,
    required this.userId,
    required this.image,
    required this.text,
    required this.dateTime,
});

  PostModel.fromJson({
    required Map<String,dynamic> json,
}){
    postId=json['id'];
    userId=json['userId'];
    image=json['image'];
    text=json['text'];
    dateTime=json['dateTime'].toDate();
  }
  Map<String,dynamic> toJson(){
    return {
      'postId':postId,
      'userId':userId,
      'image':image,
      'text':text,
      'dateTime':FieldValue.serverTimestamp(),
      'likes':likes,
    };
  }


}