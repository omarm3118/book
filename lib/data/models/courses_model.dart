class CoursesModel {
  late String name;
  late String id;
  late List booksId;

  CoursesModel.fromJson({required Map<String, dynamic> json}) {
    name = json['name'];
    id = json['id'];
    booksId = json['books'];
  }
}
