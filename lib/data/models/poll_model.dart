import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class PollModel {
  String? id;
  late String question;
  late String creatorId;
  late List<dynamic> options;
  late List? whoVoted;
  String? endDate;
  String? dateTime;

  PollModel({
    this.id,
    required this.question,
    required this.creatorId,
    required this.options,
  });

  PollModel.fromJson({
    required Map<String, dynamic> json,
  }) {
    DateFormat formatting = DateFormat().add_yMMMd().add_jm();
    whoVoted=json['whoVoted'];
    creatorId=json['creatorId'];
    id = json['pollId'];
    question = json['question'];
    dateTime = formatting.format(json['dateTime'].toDate());
    options = json['options'].map(
      (e) => Option(
        id: e['id'],
        title: e['title'],
        votes: e['votes'],
      ),
    ).toList();
    //endDate = json['endDate'];
  }

  Map<String, dynamic> toJson() {
    return {
      'creatorId': creatorId,
      'dateTime': FieldValue.serverTimestamp(),
      'question': question,
      'options': options
          .map((e) => {'id': e.id, 'title': e.title, 'votes': e.votes})
          .toList(),
    };
  }
}

class Option {
  late int id;
  late String title;
  int votes = 0;

  Option({
    required this.id,
    required this.title,
    required this.votes,
  });
}
