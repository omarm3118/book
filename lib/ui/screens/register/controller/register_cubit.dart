import 'package:book/data/models/user_model.dart';
import 'package:book/data/repositories/firebase_firestore_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/repositories/firebase_auth_repository.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final FirebaseAuthRepository firebaseAuthRepositories;
  final FirebaseFirestoreRepository firebaseFirestoreRepository;
  bool isSecure = true;
  static UserModel? _appUser;

  RegisterCubit(
      {required this.firebaseFirestoreRepository,
      required this.firebaseAuthRepositories})
      : super(RegisterInitial());

  static UserModel? get getUser => _appUser;

  static getCubit(context) => BlocProvider.of<RegisterCubit>(context);

  changePasswordVisibility() {
    isSecure = !isSecure;
    emit(ChangePasswordVisibilityState());
  }

  registerWithEmail({
    required String email,
    required String password,
    required String name,
    required String lastName,
  }) async {
    emit(RegisterUserLoadingState());
    try {
      UserModel? userCredential =
          await firebaseAuthRepositories.registerWithEmail(
        email: email,
        password: password,
        name: name,
        lastName: lastName,
      );
      if (userCredential != null) {
        _appUser = userCredential;
        await _addUserToFirestore(
          data: userCredential.toJson(),
        );
        emit(RegisterUserSuccessState());

      } else {
        emit(RegisterUserErrorState());
      }
    } catch (e) {
      emit(RegisterUserErrorState());
    }
  }

  _addUserToFirestore({required Map<String, dynamic> data}) async {
    emit(AddUserToFirestoreLoadingState());
    try {
      var create = await firebaseFirestoreRepository.createNewUser(
        uId: data['uId'],
        data: data,
      );
      if (create != 1) {
        emit(AddUserToFirestoreSuccessState());
      }
    } catch (e) {
      emit(AddUserToFirestoreErrorState());
    }
  }


}
