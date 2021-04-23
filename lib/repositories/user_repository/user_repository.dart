import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_bloc_todo/repositories/user_repository/authentication_error.dart';

class UserRepository {
  UserRepository({FirebaseAuth firebaseAuth})
      : _auth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  Future<FirebaseAuthResultStatus> signIn(
      {String email, String password}) async {
    try {
      final _credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (_credential.user == null) {
        return FirebaseAuthResultStatus.undefined;
      } else {
        return FirebaseAuthResultStatus.successful;
      }
    } on FirebaseAuthException catch (e) {
      print(e);
      return FirebaseAuthExceptionHandler.handleException(e);
    }
  }

  Future<FirebaseAuthResultStatus> signUp(
      {String email, String password, String name}) async {
    try {
      final _credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (_credential.user == null) {
        return FirebaseAuthResultStatus.undefined;
      } else {
        await _credential.user.updateProfile(displayName: name);
        return FirebaseAuthResultStatus.successful;
      }
    } on FirebaseAuthException catch (e) {
      return FirebaseAuthExceptionHandler.handleException(e);
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  bool isSignIn() {
    final _user = _auth.currentUser;
    return _user != null;
  }

  User getUser() {
    return _auth.currentUser;
  }
}
