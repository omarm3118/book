class UserModel {
  String email = '';
  String name = '';
  String lastName = '';
  String password = '';
  String uId = '';
  String phone = '';
  bool isEmailVerified = false;
  String cover = '';
  String image = '';
  String bio = '';
  List posts = const [];
  List groups = const [];
  List favoriteFields = const [];
  bool isAdmin = false;

  UserModel({
    //=> Todo when I'm register new user I will use this method to store user data then use this data in toJson method
    required this.email,
    required this.name,
    required this.lastName,
    required this.uId,
    required this.isEmailVerified,
    required this.password,
    required this.phone,
    this.image =
        'https://firebasestorage.googleapis.com/v0/b/test-e854f.appspot.com/o/Images%2FuserImage%2Fman.png?alt=media&token=4a9543eb-6780-4148-96d9-5892f12864e5',
    this.cover =
        'https://firebasestorage.googleapis.com/v0/b/test-e854f.appspot.com/o/Images%2FcoverImage%2FcoverImage.jpg?alt=media&token=65dd0953-585b-4229-9e70-f8b2ab239ef3',
    this.bio = 'اكتب سيرتك...',
    this.posts = const [],
    this.groups = const [],
    this.favoriteFields = const [],
  });

  UserModel.fromJson(
    //=> Todo when I'm receive data from firestore
    var json,
  ) {
    email = json['email'];
    name = json['name'];
    lastName = json['lastName'];
    uId = json['uId'];
    phone = json['phone'];
    password = json['password'];
    isEmailVerified = json['isEmailVerified'];
    image = json['image'];
    bio = json['bio'];
    cover = json['cover'];
    posts = json['posts'];
    groups = json['groups'];
    favoriteFields = json['favoriteFields'];
    isAdmin = json['isAdmin'];
  }

  Map<String, dynamic> toJson() {
    //=> Todo when I'm send data to firestore I use this method
    return {
      'uId': uId,
      'email': email,
      'name': name,
      'lastName': lastName,
      'phone': phone,
      'password': password,
      'isEmailVerified': isEmailVerified,
      'cover': cover,
      'image': image,
      'bio': bio,
      'posts': posts,
      'groups': groups,
      'favoriteFields': favoriteFields,
      'isAdmin': isAdmin,
    };
  }
}

class BookMarks {
  late String bookName;
  late String bookId;
  late int pageNumber;
  late int allPageNumber;

  BookMarks.fromJson({required Map<String, dynamic> json}) {
    bookName = json['bookName'];
    bookId = json['bookId'];
    pageNumber = json['pageNumber'];
    allPageNumber = json['allPageNumber'];
  }
}
