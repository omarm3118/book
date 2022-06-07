import 'package:book/data/models/courses_model.dart';
import 'package:book/data/repositories/firebase_firestore_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'culture_courses_state.dart';

class CultureCoursesCubit extends Cubit<CultureCoursesState> {
  CultureCoursesCubit({required this.firebaseFirestoreRepository})
      : super(CultureCoursesInitial());
  final FirebaseFirestoreRepository firebaseFirestoreRepository;
  List<CoursesModel> courses = [];

  getCourses() async {
    courses.clear();
    emit(GetCoursesLoadingState());
    List<CoursesModel>? docs = await firebaseFirestoreRepository.getCourses();
    if (docs != null) {
      courses = docs;
      emit(GetCoursesSuccessState());
    } else {
      emit(GetCoursesErrorState());
    }
  }
}
