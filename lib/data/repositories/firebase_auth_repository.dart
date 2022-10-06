import 'package:book/data/models/user_model.dart';
import 'package:book/data/web_services/firebase_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthRepository {
  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();

  Future<UserModel?>? registerWithEmail({
    required email,
    required password,
    required name,
    required lastName}) async {
    UserCredential? userCredential = await _firebaseAuthService
        .firebaseRegisterWithEmail(email: email, password: password);
    if (userCredential == null) {
      return null;
    }
    return UserModel(
      email: email,
      name: name,
      uId: userCredential.user!.uid,
      isEmailVerified: userCredential.user!.emailVerified,
      phone: userCredential.user!.phoneNumber ?? '',
      lastName: lastName,
    );
  }

  signInWithEmail({
    required String email,
    required String password,
  }) async {
    UserCredential? userCredential = await _firebaseAuthService
        .firebaseSignInWithEmail(email: email, password: password);
    return userCredential;
  }
}
