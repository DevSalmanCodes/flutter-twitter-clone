import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:twitter/constants/firebase_consts.dart';
import 'package:twitter/methods/storage_methods.dart';
import 'package:twitter/models/user.dart' as user;
import 'package:twitter/utils/snackbar.dart';

import '../models/user.dart';

class UserProvider extends ChangeNotifier {
  Future<user.User?> getUser(uid) async {
    try {
      DocumentSnapshot user =
          await firestore.collection(usersCollection).doc(uid).get();

      return User.fromJson(user);
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      throw 'An error occured';
    }
  }

  Future<void> followUser(
    List followers,
    followUid,
  ) async {
    final bool isFollowed = followers.contains(currentUserUid);

    try {
      if (isFollowed) {
        await firestore.collection(usersCollection).doc(followUid).update({
          "followers": FieldValue.arrayRemove([currentUserUid])
        });
        await firestore.collection(usersCollection).doc(currentUserUid).update({
          "following": FieldValue.arrayRemove([followUid]),
        });
      } else {
        await firestore.collection(usersCollection).doc(followUid).update({
          "followers": FieldValue.arrayUnion([currentUserUid]),
        });
        await firestore.collection(usersCollection).doc(followUid).update({
          "followers": FieldValue.arrayUnion([currentUserUid])
        });
      }
    } catch (e) {
      CustomSnackBar.error(e.toString());
    }
  }

  Future<void> updateProfile(File? profPic, String? name, String? bio) async {
    try {
      if (profPic != null) {
        final url =
            await StorageMethods.uploadImage(profPic, 'profilePics', false);
        await firestore.collection(usersCollection).doc(currentUserUid).update({
          "profPic": url,
        });
      }
      if (name != null) {
        await firestore.collection(usersCollection).doc(currentUserUid).update({
          "username": name,
        });
      }
      if (bio != null) {
        await firestore.collection(usersCollection).doc(currentUserUid).update({
          "bio": bio,
        });
      }
    } catch (e) {
      CustomSnackBar.error(e.toString());
    }
  }

  Future<List<User>> getSearchUsers(searchText) async {
    try {
      final snap = await firestore
          .collection(usersCollection)
          .where('username', isGreaterThanOrEqualTo: searchText)
          .get();
      List<User> users = [];
      for (var doc in snap.docs) {
        users.add(User.fromJson(doc));
      }
      return users;
    } catch (e) {
      throw e.toString();
    }
  }
}
