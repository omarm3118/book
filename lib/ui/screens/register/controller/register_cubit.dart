import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  bool isSecure = true;

  RegisterCubit() : super(RegisterInitial());



  static getCubit(context) => BlocProvider.of<RegisterCubit>(context);

  changePasswordVisibility() {
    isSecure = !isSecure;
    emit(ChangePasswordVisibility());
  }
}
