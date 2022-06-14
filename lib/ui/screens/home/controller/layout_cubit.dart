import 'dart:io';

import 'package:book/constants/strings.dart';
import 'package:book/data/models/book_model.dart';
import 'package:book/data/models/user_model.dart';
import 'package:book/data/repositories/firebase_firestore_repository.dart';
import 'package:book/data/repositories/firebase_storage_repository.dart';
import 'package:book/ui/screens/home/views/dashboard_screen.dart';
import 'package:book/ui/screens/home/views/search_screen.dart';
import 'package:book/ui/widgets/toast.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';

import 'package:http/http.dart' as http;

import '../../my_groups/my_groups_screen.dart';
import '../views/saved_posts_screeen.dart';

part 'layout_state.dart';

class LayoutCubit extends Cubit<LayoutState> {
  LayoutCubit(
      {required this.firebaseFirestoreRepository,
      required this.firebaseStorageRepository})
      : super(LayoutInitial());

  final FirebaseFirestoreRepository firebaseFirestoreRepository;
  final FirebaseStorageRepository firebaseStorageRepository;
  static UserModel? _appUser;
  static List<UserModel>? _users;
  File? pdfFile;
  File? userImage;
  File? coverImage;
  bool isSearch = false;

  static UserModel? get getUser => _appUser;

  static List<UserModel>? get allUsers => _users;

  static LayoutCubit getCubit(context) => BlocProvider.of<LayoutCubit>(context);

  List<BookModel> books = [];
  static List<BookModel> booksStatic = [];
  List layoutScreens = [
    const DashboardScreen(),
    SearchScreen(),
    SavedPostsScreen(), // MyGroupsScreen(),
    const MyGroupsScreen(), // MyGroupsScreen(),
  ];
  int navBarIndex = 0;

  changeNavBar(int index) {
    navBarIndex = index;
    emit(ChangeNavBarState());
  }

  Future<void> imagePicker({
    bool isCover = false,
  }) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker
        .pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
      maxHeight: 600,
      imageQuality: 75,
    )
        .then((XFile? value) {
      if (value != null) {
        if (isCover) {
          coverImage = File(value.path);
        } else {
          userImage = File(value.path);
        }
      }
      emit(ImagePickerSuccess());
    }).catchError((e) {
      emit(ImagePickerError());
      showingToast(
        msg: e.toString(),
        state: ToastState.error,
      );
    });
  }

  getUserInfo() {
    emit(GetUserLoadingState());
    User? userK = FirebaseAuth.instance.currentUser;
    String userID = userK!.uid;

    try {
      Stream<DocumentSnapshot<Map<String, dynamic>>>? user =
          firebaseFirestoreRepository.getUserInfo(userID: userID);
      if (user != null) {
        user.listen((event) {
          _appUser = UserModel.fromJson(
            event.data(),
          );
          getBookMarks(userId: userID);
          emit(GetUserSuccessState());
        }).onError((handleError) {
          emit(GetUserErrorState());
        });
      } else {
        emit(GetUserErrorState());
      }
    } catch (e) {
      emit(GetUserErrorState());
    }
  }

  getBookMarks({required userId}) {
    emit(GetBookMarksLoadingState());
    try {
      Stream<QuerySnapshot<Map<String, dynamic>>>? bookMarks =
          firebaseFirestoreRepository.getBookMark(userId: userId);
      if (bookMarks != null) {
        bookMarks.listen((event) {
          _appUser!.bookMarks!.clear();
          for (var element in event.docs) {
            _appUser?.bookMarks?.add(
              BookMarks.fromJson(
                json: element.data(),
              ),
            );
          }
          emit(GetBookMarksSuccessState());
        }).onError((handleError) {
          emit(GetBookMarksErrorState());
        });
      } else {
        emit(GetBookMarksErrorState());
      }
    } catch (e) {
      emit(GetBookMarksErrorState());
    }
  }

  getAllUsers() async {
    var list = await firebaseFirestoreRepository.getAllUsers();
    if (list != null) {
      _users = list;
    }
  }

  getBooks() async {
    emit(GetBooksLoadingState());
    try {
      var bookCollection = await firebaseFirestoreRepository.getBooks();
      if (bookCollection == null) {
        emit(GetBooksErrorState());
      } else {
        books = bookCollection;
        booksStatic = books;
        emit(GetBooksSuccessState());
      }
    } catch (e) {
      emit(GetBooksErrorState());
    }
  }

  pushBookRate({
    required String bookId,
    required String comment,
    required double bookRate,
  }) async {
    emit(PushRateLoadingState());
    var value = await firebaseFirestoreRepository.pushBookRate(
      bookId: bookId,
      bookRate: bookRate,
      userId: _appUser!.uId,
      comment: comment,
    );
    if (value == null) {
      emit(PushRateErrorState());
    } else {
      emit(PushRateSuccessState());
      getBookRate(bookId: bookId);
    }
  }

  getBookRate({required String bookId}) async {
    emit(GetRateLoadingState());

    Map<String, dynamic>? rev =
        await firebaseFirestoreRepository.getBookRate(bookId: bookId);

    if (rev != null) {
      for (var element in books) {
        if (element.id == bookId) {
          element.bookRate = rev['totalRate'];
          element.bookReviews = rev['reviews'];
          break;
        }
      }
      emit(GetRateSuccessState());
    } else {
      emit(GetRateErrorState());
    }
  }

  Future<File?>? loadPdf(
      {required String url,
      required String bookName,
      required String userId,
      required String bookId}) async {
    pdfFile = null;
    emit(GetPdfLoadingState());
    try {
      await firebaseFirestoreRepository.addLastBookToUserDashBoard(
        userId: userId,
        bookId: bookId,
      );
      if (await _checkIfFileExist(bookName)) {
        pdfFile = await _loadPdfFormMemory(bookName);
        print(pdfFile!.path);
        emit(GetPdfSuccessState());
        return pdfFile;
      }

      final response = await http.get(
        Uri.parse(url),
      );
      await firebaseFirestoreRepository.updateUserBooks(
        userId: userId,
        bookId: bookId,
      );

      final bytes = response.bodyBytes;
      pdfFile = await _storeFile(bytes, bookName);
      emit(GetPdfSuccessState());
      return pdfFile;
    } catch (e) {
      emit(GetPdfErrorState());
      showingToast(msg: e.toString(), state: ToastState.error);
    }
    return null;
  }

  Future<File> _storeFile(List<int> bytes, String bookName) async {
    final fileName = bookName;
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$fileName.pdf');
    File urlFile = await file.writeAsBytes(
      bytes,
    );
    return urlFile;
  }

  _checkIfFileExist(String bookName) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$bookName.pdf');
    return await file.exists();
  }

  _loadPdfFormMemory(String bookName) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$bookName.pdf');
    return file;
  }

  void openSearch(context) {
    if (!isSearch) {
      ModalRoute.of(context)!.addLocalHistoryEntry(LocalHistoryEntry(
        onRemove: exitSearch,
      ));
      isSearch = true;
      emit(SearchState());
    }
    emit(SearchState());
  }

  void exitSearch() {
    if (isSearch) {
      isSearch = false;
      emit(ExitSearchState());
    }
  }

  addBookMark({
    required String bookId,
    required int pageNumber,
    required int allPageNumber,
    required String bookName,
  }) async {
    emit(AddBookMarkLoadingState());
    var check = await firebaseFirestoreRepository.addBookMark(
      userId: _appUser!.uId,
      bookId: bookId,
      pageNumber: pageNumber,
      allPageNumber: allPageNumber,
      bookName: bookName,
    );
    if (check != 1) {
      emit(AddBookMarkSuccessState());
    } else {
      emit(AddBookMarkErrorState());
    }
  }

  updateUserTrack({
    required String userId,
    required String trackName,
    required int tracValue,
    String? secondTrackName,
    int? secondTrackValue,
  }) async {
    emit(UpdateTrackLoadingState());
    await firebaseFirestoreRepository.updateUserTrack(
      userId: userId,
      trackName: trackName,
      tracValue: tracValue,
      secondTrackName: secondTrackName,
      secondTrackValue: secondTrackValue,
    );
    emit(UpdateTrackSuccessState());
  }

  changeNumber() {
    emit(ChangeNumber());
  }

  signOut(context) async {
    try {

      FirebaseAuth.instance.signOut();
      Navigator.pushReplacementNamed(context, loginRoute);
      print('heel');
    } catch (e) {
      showingToast(msg: e.toString(), state: ToastState.error);
    }
  }

  Future<List?>? getSavedPosts() async {
    List dataSet = [];
    QuerySnapshot<Map<String, dynamic>>? listOf;
    if (_appUser != null) {
      listOf = await firebaseFirestoreRepository.getSavedPosts(
          userId: _appUser!.uId);
    }
    if (listOf != null) {
      listOf.docs.forEach((element) {
        dataSet.add({
          'text': element.data()['text'],
          'image': element.data()['image'],
          'userId': element.data()['userPost'],
        });
      });
      return dataSet;
    }
    return null;
  }

  updateUserInfo({required String name, required String bio}) async {
    emit(UpdateDataLoadingState());
    String? uImage;
    String? cImage;
    try {
      if (userImage != null)
        uImage =
            await _updateUserImage(uImage: userImage, userId: _appUser!.uId);
      if (coverImage != null)
        cImage =
            await _updateCoverImage(cImage: userImage, userId: _appUser!.uId);
      await firebaseFirestoreRepository.updateUserInfo(
        name: name,
        bio: bio,
        userImage: uImage,
        coverImage: cImage,
        userId: _appUser!.uId,
      );

      userImage = null;
      coverImage = null;
      emit(UpdateDataSuccessState());
    } catch (e) {
      emit(UpdateDataErrorState());

      showingToast(
        msg: e.toString(),
        state: ToastState.error,
      );
    }
  }

  _updateUserImage({required uImage, required userId}) async {
    String? _userImage = await firebaseStorageRepository.uploadUserPhoto(
        userImage: uImage, userId: userId);
    if (_userImage != null) return _userImage;
    return _appUser!.image;
  }

  _updateCoverImage({required cImage, required userId}) async {
    String? _userCover = await firebaseStorageRepository.uploadCoverPhoto(
        coverImage: cImage, userId: userId);
    if (_userCover != null) return _userCover;
    return _appUser!.cover;
  }
}
