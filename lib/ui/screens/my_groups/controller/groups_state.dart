part of 'groups_cubit.dart';

@immutable
abstract class GroupsState {}

class GroupsInitial extends GroupsState {}

class CreateGroupLoadingState extends GroupsState{}
class CreateGroupSuccessState extends GroupsState{}
class CreateGroupErrorState extends GroupsState{}

class GetGroupsLoadingState extends GroupsState{}
class GetGroupsSuccessState extends GroupsState{}
class GetGroupsErrorState extends GroupsState{}


class AddToGroupLoadingState extends GroupsState{}
class AddToGroupSuccessState extends GroupsState{}
class AddToGroupErrorState extends GroupsState{}

class ImagePickerSuccess extends GroupsState{}
class ImagePickerError extends GroupsState{}

class ClearImage extends GroupsState{}

