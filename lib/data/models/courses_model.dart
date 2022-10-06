class CoursesModel {
  late String name;
  late String id;
  late List booksId;
  String? imageLink;

  CoursesModel.fromJson({required Map<String, dynamic> json}) {
    name = json['name'];
    id = json['id'];
    booksId = json['books'];
    imageLink=json['imageLink'];
  }
}
