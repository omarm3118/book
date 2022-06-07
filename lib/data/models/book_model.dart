import 'package:intl/intl.dart';

class BookModel {
  String? name;
  String? authorName;
  String? description;
  String? id;
  String? imageLink;
  String? pdfLink;
  double bookRate = 0;
  List<BookReview> bookReviews = [];

  BookModel.fromJson({
    required Map<String, dynamic> json,
  }) {
    name = json['bookName'];
    authorName = json['authorName'];
    description = json['bookDescription'];
    id = json['id'];
    imageLink = json['bookImageLink'];
    pdfLink = json['bookPdfLink'];
     bookRate = json['bookRate'] ?? 0;
  }
}

class BookReview {
  String? userId;
  String? bookComment;
  double? bookRate;
  String? date;

  BookReview.fromJson({required Map<String, dynamic> json}) {
    DateFormat formatting = DateFormat().add_yMd();
    userId = json['userId'];
    bookComment = json['comment'];
    bookRate = json['bookRate'];
    date = formatting.format(json['date'].toDate());
  }
}
