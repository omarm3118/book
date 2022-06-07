import 'package:book/ui/widgets/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseInstance = FirebaseAuth.instance;

  Future<UserCredential?>? firebaseRegisterWithEmail(
      {required String email, required String password}) async {
    try {
      final UserCredential credential =
          await _firebaseInstance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showingToast(
            msg: 'The password provided is too weak.', state: ToastState.error);
      } else if (e.code == 'email-already-in-use') {
        //Todo error or warning
        showingToast(
          msg: 'The account already exists for that email.',
          state: ToastState.error,
        );
      } else if (e.code == 'network-request-failed') {
        showingToast(
          msg: 'No Internet Connection.',
          state: ToastState.error,
        );
      } else {
        showingToast(
          msg: '${e.code}.',
          state: ToastState.error,
        );
      }
    } catch (e) {
      showingToast(
        msg: e.toString(),
        state: ToastState.error,
      );
    }
    return null;
  }

  Future<UserCredential?>? firebaseSignInWithEmail(
      {required String email, required String password}) async {
    try {
      final UserCredential userCredential = await _firebaseInstance
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showingToast(
          msg: 'user-not-found.',
          state: ToastState.error,
        );
      } else if (e.code == 'wrong-password') {
        showingToast(
          msg: 'wrong-password.',
          state: ToastState.error,
        );
      } else if (e.code == 'network-request-failed') {
        showingToast(
          msg: 'No Internet Connection.',
          state: ToastState.error,
        );
      } else {
        showingToast(
          msg: '${e.message}.',
          state: ToastState.error,
        );
      }
    } catch (e) {
      showingToast(
        msg: e.toString(),
        state: ToastState.error,
      );
    }
    return null;
  }
}
