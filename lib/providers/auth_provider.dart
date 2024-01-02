import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:twitter/constants/firebase_consts.dart';
import 'package:twitter/exceptions/auth_exceptions.dart';
import 'package:twitter/methods/storage_methods.dart';
import 'package:twitter/models/user.dart' as user;
import 'package:twitter/screens/login.dart';
import 'package:twitter/screens/nav_bar.dart';
import 'package:twitter/utils/snackbar.dart';

class AuthProvider extends ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;
  void setLoading(bool value) {
    _loading = value;
  }

  Future<void> signUp(String email,String password,String name, String bio,
      File? profilePic) async {
    setLoading(true);
  notifyListeners();
    try {
      await auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        String? url;
        if (profilePic != null) {
          url = await StorageMethods.uploadImage(
              profilePic, 'profilePics', false);
        } else {
          url = '';
        }
        storeUserData(name, email, password, bio, url);
        setLoading(false);
        notifyListeners();
        CustomSnackBar.success('Account created succesfully');
        Get.offAll(() => const NavBar());
      });
    } on FirebaseAuthException catch (e) {
      AuthExceptions.authExceptions(e);
      setLoading(false);
      notifyListeners();
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<void> login(String email, String password) async {
    setLoading(true);
    notifyListeners();
    try {
      await auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        setLoading(false);
        notifyListeners();
        Get.offAll(() => const NavBar());
        CustomSnackBar.success("Logged in succesfully");
      });
    } on FirebaseAuthException catch (e) {
      setLoading(false);
      notifyListeners();
     AuthExceptions.authExceptions(e);
      CustomSnackBar.error(e.toString());
    }
  }

  Future<void> storeUserData(
    String username,
    String email,
    String password,
    String bio,
    String profilePic,
  ) async {
    try {
      user.User newUser = user.User(
          email: email,
          username: username,
          followers: [],
          following: [],
          password: password,
          bio: bio,
          profilePic: profilePic,
          uid: auth.currentUser!.uid);
      await firestore
          .collection(usersCollection)
          .doc(auth.currentUser!.uid)
          .set(newUser.toJson());
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<void> logOut() async {
    try {
      await auth.signOut().then((value) {
        Get.offAll(() => const Login());
      });
    } on FirebaseAuthException catch (e) {
      CustomSnackBar.error(e.toString());
    }
  }
}
