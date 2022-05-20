import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  bool isSecure = true;

  LoginCubit() : super(LoginInitial());

  static getCubit(context) => BlocProvider.of<LoginCubit>(context);

  changePasswordVisibility() {
    isSecure = !isSecure;
    emit(ChangePasswordVisibility());
  }
}
