import 'dart:io';

import 'package:book/data/models/book_model.dart';
import 'package:book/data/models/user_model.dart';
import 'package:book/data/repositories/firebase_firestore_repository.dart';
import 'package:book/ui/screens/home/views/dashboard_screen.dart';
import 'package:book/ui/screens/home/views/search_screen.dart';
import 'package:book/ui/widgets/toast.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';

import 'package:http/http.dart' as http;

import '../../my_groups/my_groups_screen.dart';
import '../views/saved_posts_screeen.dart';

part 'layout_state.dart';

class LayoutCubit extends Cubit<LayoutState> {
  LayoutCubit({required this.firebaseFirestoreRepository})
      : super(LayoutInitial());

  final FirebaseFirestoreRepository firebaseFirestoreRepository;
  static UserModel? _appUser;
  File? pdfFile;
  bool isSearch = false;

  static UserModel? get getUser => _appUser;

  static LayoutCubit getCubit(context) => BlocProvider.of<LayoutCubit>(context);

  List<BookModel> books = [];

  List layoutScreens = [
    const DashboardScreen(),
    SearchScreen(),
    SavedPostsScreen(), // MyGroupsScreen(),
    MyGroupsScreen(), // MyGroupsScreen(),
  ];
  int navBarIndex = 0;

  changeNavBar(int index) {
    navBarIndex = index;
    emit(ChangeNavBarState());
  }

  getUserInfo() {
    emit(GetUserLoadingState());
    String userID = FirebaseAuth.instance.currentUser!.uid;
    try {
      Stream<DocumentSnapshot<Map<String, dynamic>>>? user =
          firebaseFirestoreRepository.getUserInfo(userID: userID);
      if (user != null) {
        user.listen((event) {

          _appUser = UserModel.fromJson(
            event.data(),
          );
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

  getBooks() async {
    emit(GetBooksLoadingState());
    try {
      var bookCollection = await firebaseFirestoreRepository.getBooks();
      if (bookCollection == null) {
        emit(GetBooksErrorState());
      } else {
        books = bookCollection;
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
      {required String url, required String bookName}) async {
    pdfFile = null;
    emit(GetPdfLoadingState());
    print(url + bookName);
    try {
      final response = await http.get(
        Uri.parse(url),
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
}
