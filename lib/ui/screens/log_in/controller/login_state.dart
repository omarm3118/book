part of 'login_cubit.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class ChangePasswordVisibility extends LoginState{}


class SignInUserLoadingState extends LoginState{}
class SignInUserSuccessState extends LoginState{}
class SingInUserErrorState extends LoginState{}

