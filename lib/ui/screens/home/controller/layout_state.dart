part of 'layout_cubit.dart';

@immutable
abstract class LayoutState {}

class LayoutInitial extends LayoutState {}

class ChangeNavBarState extends LayoutState {}



class GetUserLoadingState extends LayoutState{}
class GetUserSuccessState extends LayoutState{}
class GetUserErrorState extends LayoutState{}

class GetBookMarksLoadingState extends LayoutState{}
class GetBookMarksSuccessState extends LayoutState{}
class GetBookMarksErrorState extends LayoutState{}



class GetBooksLoadingState extends LayoutState{}
class GetBooksSuccessState extends LayoutState{}
class GetBooksErrorState extends LayoutState{}



class GetRateLoadingState extends LayoutState{}
class GetRateSuccessState extends LayoutState{}
class GetRateErrorState extends LayoutState{}

class PushRateLoadingState extends LayoutState{}
class PushRateSuccessState extends LayoutState{}
class PushRateErrorState extends LayoutState{}

class GetPdfLoadingState extends LayoutState{}
class GetPdfSuccessState extends LayoutState{}
class GetPdfErrorState extends LayoutState{}

class AddBookMarkLoadingState extends LayoutState{}
class AddBookMarkSuccessState extends LayoutState{}
class AddBookMarkErrorState extends LayoutState{}


class SearchState extends LayoutState{}
class ExitSearchState extends LayoutState{}
class ChangeNumber extends LayoutState{}

class UpdateTrackLoadingState extends LayoutState{}
class UpdateTrackSuccessState extends LayoutState{}
class UpdateTrackErrorState extends LayoutState{}

class ImagePickerSuccess extends LayoutState{}
class ImagePickerError extends LayoutState{}



class UpdateDataLoadingState extends LayoutState{}

class UpdateDataSuccessState extends LayoutState{}

class UpdateDataErrorState extends LayoutState{}
