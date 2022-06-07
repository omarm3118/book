part of 'register_cubit.dart';

abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class ChangePasswordVisibilityState extends RegisterState{}

class RegisterUserLoadingState extends RegisterState{}
class RegisterUserSuccessState extends RegisterState{}
class RegisterUserErrorState extends RegisterState{}


class AddUserToFirestoreLoadingState extends RegisterState{}
class AddUserToFirestoreSuccessState extends RegisterState{}
class AddUserToFirestoreErrorState extends RegisterState{}