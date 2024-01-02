import 'package:firebase_auth/firebase_auth.dart';
import 'package:twitter/utils/snackbar.dart';

class AuthExceptions {
  static void authExceptions(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        CustomSnackBar.error('Invalid email');
        break;
      case 'email-already-in-use':
        CustomSnackBar.error('Email already in use');
        break;
      case 'weak-password':
        CustomSnackBar.error('Weak password');
        break;
      case 'user-disabled':
        CustomSnackBar.error('User disabled');
        break;
      case 'user-not-found':
        CustomSnackBar.error('User not found');
        break;
      case 'wrong-password':
        CustomSnackBar.error('Wrong password');
      default:
    }
  }
}
