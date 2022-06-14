import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class MessageModel {
  String text = '';
  String senderId = '';
  String receiverId = '';
  String? dateTime = '';
  String image = '';
  String? time = '';
  String? date = '';

  MessageModel({
    //=> Todo when I'm register new user I will use this method to store user data then use this data in toJson method
    required this.text,
    required this.receiverId,
    required this.senderId,
    required this.image,
  });

  MessageModel.fromJson(
      //=> Todo when I'm receive data from firestore
      {required Map<String, dynamic> json}) {
    DateFormat formatting = DateFormat().add_yMMMd().add_jm();
    DateFormat formattingTime = DateFormat().add_jm();
    DateFormat formattingDate = DateFormat().add_yMMMd();

    text = json['text'];
    dateTime = formatting.format(json['dateTime'].toDate());
    time = formattingTime.format(json['dateTime'].toDate());
    date = formattingDate.format(json['dateTime'].toDate());
    receiverId = json['receiverId'];
    senderId = json['senderId'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {



    //=> Todo when I'm send data to firestore I use this method
    return {
      'senderId': this.senderId,
      'receiverId': this.receiverId,
      'dateTime': FieldValue.serverTimestamp(),
      'text': this.text,
      'image': this.image,
    };



  }
}
