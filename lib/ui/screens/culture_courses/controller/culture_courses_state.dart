part of 'culture_courses_cubit.dart';


abstract class CultureCoursesState {}

class CultureCoursesInitial extends CultureCoursesState {}

class GetCoursesLoadingState extends CultureCoursesState{}
class GetCoursesSuccessState extends CultureCoursesState{}
class GetCoursesErrorState extends CultureCoursesState{}
