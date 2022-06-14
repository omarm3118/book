import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class GroupModel {
  String? name;
  String? id;
  String? groupBio;
  String? createdAt;
  String? createdBy;
  String? groupImage;
  List? admins;
  List? members;
  bool inIt=false;

  GroupModel({
    required this.name,
    required this.groupBio,
   required this.id,
    this.groupImage =
        'https://img.freepik.com/free-vector/hand-drawn-book-club-illustration_23-2149381723.jpg?w=740',
    this.members,
    required this.admins,
    required this.createdBy,
  });

  GroupModel.fromJson({required Map data}) {
    DateFormat formatting = DateFormat().add_yMMMd().add_jm();

    name = data['name'];
    id = data['id'];
    createdAt = formatting.format(data['createdAt'].toDate());
    createdBy = data['createdBy'];
    groupImage = data['groupImage'];
    admins = data['admins'];
    members = data['members'];
    groupBio = data['groupBio'];
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
      'createdAt': FieldValue.serverTimestamp(),
      'createdBy': createdBy,
      'groupImage': groupImage ?? '',
      'admins': admins ?? [],
      'members': members ?? [],
      'groupBio': groupBio,
    };
  }
}
