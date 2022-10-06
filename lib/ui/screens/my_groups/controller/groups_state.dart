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

class CreatePostLoadingState extends GroupsState{}
class CreatePostSuccessState extends GroupsState{}
class CreatePostErrorState extends GroupsState{}

class GetPostsLoadingState extends GroupsState{}
class GetPostsSuccessState extends GroupsState{}
class GetPostsErrorState extends GroupsState{}


class ClearImage extends GroupsState{}
class ChangeImageFitState extends GroupsState{}

class LikePostSuccessState extends GroupsState{}
class Searching extends GroupsState{}

class AddCommentLoadingState extends GroupsState{}
class AddCommentSuccessState extends GroupsState{}

class GetCommentLoadingState extends GroupsState{}
class GetCommentSuccessState extends GroupsState{}

class SavePostLoadingState extends GroupsState{
late String postId;
SavePostLoadingState({required this.postId});
}
class SavePostSuccessState extends GroupsState{}


class SendMessageLoadingState extends GroupsState{}
class SendMessageSuccessState extends GroupsState{}
class SendMessageErrorState extends GroupsState{}


class GetMessagesLoadingState extends GroupsState{}
class GetMessagesSuccessState extends GroupsState{}
class GetMessagesErrorState extends GroupsState{}



class GetPollsLoadingState extends GroupsState{}
class GetPollsSuccessState extends GroupsState{}
class GetPollsErrorState extends GroupsState{}


class CreatePollLoadingState extends GroupsState{}
class CreatePollSuccessState extends GroupsState{}
class CreatePollErrorState extends GroupsState{}