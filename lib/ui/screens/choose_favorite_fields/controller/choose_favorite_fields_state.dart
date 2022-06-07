part of 'choose_favorite_fields_cubit.dart';

@immutable
abstract class ChooseFavoriteFieldsState {}

class ChooseFavoriteFieldsInitial extends ChooseFavoriteFieldsState {}


class AddFieldLoadingState extends ChooseFavoriteFieldsState {}
class AddFieldSuccessState extends ChooseFavoriteFieldsState {}
class AddFieldErrorState extends ChooseFavoriteFieldsState {}


