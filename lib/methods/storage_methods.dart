import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:twitter/constants/firebase_consts.dart';
import 'package:uuid/uuid.dart';

class StorageMethods {
  static Future<String> uploadImage(
      File file, String child, bool isTweet) async {
    try {
      Reference ref = storage.ref().child(child).child(auth.currentUser!.uid);
      if (isTweet) {
        final String id = const Uuid().v1();
        ref = ref.child(id);
      }
       UploadTask task = ref.putFile(file);
      TaskSnapshot snapshot = await task;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    return '';
  }
}
