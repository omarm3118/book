import 'package:book/data/repositories/firebase_auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final FirebaseAuthRepository firebaseAuthRepositories;
  bool isSecure = true;


  LoginCubit({
    required this.firebaseAuthRepositories,
  }) : super(LoginInitial());

  static getCubit(context) => BlocProvider.of<LoginCubit>(context);

  changePasswordVisibility() {
    isSecure = !isSecure;
    emit(ChangePasswordVisibility());
  }

  signInWithEmail({required String email, required String password}) async {
    emit(SignInUserLoadingState());
    try {
      final UserCredential? userCredential = await firebaseAuthRepositories
          .signInWithEmail(email: email, password: password);
      if (userCredential != null) {
         emit(SignInUserSuccessState());
      } else {
        emit(SingInUserErrorState());
      }
    } catch (e) {
      emit(SingInUserErrorState());
    }
  }

}
