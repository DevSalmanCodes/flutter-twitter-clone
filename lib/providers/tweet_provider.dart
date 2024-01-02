import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:twitter/constants/firebase_consts.dart';
import 'package:twitter/methods/storage_methods.dart';
import 'package:twitter/models/comment.dart';
import 'package:twitter/models/tweet.dart';
import 'package:twitter/utils/snackbar.dart';
import 'package:uuid/uuid.dart';

class TweetProvider extends ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;
  final List<Tweet> _tweets = [];
  List<Tweet> get tweets => _tweets;

  setLoading(bool value) {
    _loading = value;
  }

  Future<void> uploadTweet(
    String desc,
    File? file,
  ) async {
    final tweetId = const Uuid().v4();
    final currentUser =
        await firestore.collection(usersCollection).doc(currentUserUid).get();
    final userData = currentUser.data() as Map<String, dynamic>;

    String url;

    if (file != null) {
      setLoading(true);
      notifyListeners();
      url = await StorageMethods.uploadImage(file, "Tweets", true);
    } else {
      url = '';
    }

    Tweet newTweet = Tweet(
        description: desc,
        uid: currentUserUid,
        username: userData['username'],
        likes: [],
        tweetId: tweetId,
        datePublished: DateTime.now(),
        photoUrl: url,
        profImage: userData['profilePic'],
        comments: []);

    try {
      setLoading(true);
      notifyListeners();
      await firestore
          .collection(tweetsCollection)
          .doc(tweetId)
          .set(newTweet.toJson());
      setLoading(false);
      notifyListeners();
      Get.back();
    } catch (e) {
      throw e.toString();
    }
  }

  Stream<List<Tweet>> getTweets() {
    try {
      final snap = firestore
          .collection(tweetsCollection)
          .orderBy('datePublished', descending: true)
          .snapshots();
      return snap.map((QuerySnapshot item) {
        List<Tweet> tweets = [];

        for (QueryDocumentSnapshot tweet in item.docs) {
          tweets.add(Tweet.fromJson(tweet));
        }
        return tweets;
      });
    } catch (e) {
      CustomSnackBar.error(e.toString());
      throw 'An error occured';
    }
  }

  Future<void> likeTweet(tweetId, List likes) async {
    try {
      final bool isLiked = likes.contains(currentUserUid);
      if (isLiked) {
        await firestore.collection(tweetsCollection).doc(tweetId).update({
          "likes": FieldValue.arrayRemove([currentUserUid])
        });
      } else {
        await firestore.collection(tweetsCollection).doc(tweetId).update({
          "likes": FieldValue.arrayUnion([currentUserUid])
        });
      }
    } catch (e) {
      CustomSnackBar.error(e.toString());
    }
  }

  Future<void> postComment(tweetId, commentText) async {
    final currentUser =
        await firestore.collection(usersCollection).doc(currentUserUid).get();
    final userData = currentUser.data() as Map<String, dynamic>;
    final String commentId = const Uuid().v4();

    Comment newComment = Comment(
        comment: commentText,
        username: userData['username'],
        uid: currentUserUid,
        profilePic: userData['profilePic'],
        likes: [],
        commentId: commentId,
        datePublished: DateTime.now());

    try {
      await firestore
          .collection(tweetsCollection)
          .doc(tweetId)
          .collection(commentCollection)
          .doc(commentId)
          .set(newComment.toJson());
    } catch (e) {
      CustomSnackBar.error(e.toString());
    }
  }

  Stream<List<Comment>> getComments(tweetId) {
    try {
      var snap = firestore
          .collection(tweetsCollection)
          .doc(tweetId)
          .collection(commentCollection)
          .snapshots();

      return snap.map((item) {
        List<Comment> comments = [];
        for (var comment in item.docs) {
          comments.add(Comment.fromJson(comment));
        }
        return comments;
      });
    } catch (e) {
      CustomSnackBar.error(e.toString());
      throw 'An error occured';
    }
  }

  Future<void> likeComment(tweetId, commentId, List likes) async {
    final bool isLiked = likes.contains(currentUserUid);
    try {
      if (isLiked) {
        await firestore
            .collection(tweetsCollection)
            .doc(tweetId)
            .collection(commentCollection)
            .doc(commentId)
            .update({
          "likes": FieldValue.arrayRemove([currentUserUid])
        });
      } else {
        await firestore
            .collection(tweetsCollection)
            .doc(tweetId)
            .collection(commentCollection)
            .doc(commentId)
            .update({
          "likes": FieldValue.arrayUnion([currentUserUid])
        });
      }
    } catch (e) {
      CustomSnackBar.error(e.toString());
    }
  }

  Future<void> deleteTweet(tweetId) async {
    try {
      final doc = firestore.collection(tweetsCollection).doc(tweetId);
      await doc.delete();
    } catch (e) {
      CustomSnackBar.error(e.toString());
    }
  }

  Stream<List<Tweet>> getUserTweets(uid) {
    try {
      final snap = firestore
          .collection(tweetsCollection)
          .where('uid', isEqualTo: uid)
          .snapshots();
      return snap.map((snap) {
        List<Tweet> list = [];
        for (QueryDocumentSnapshot doc in snap.docs) {
          list.add(Tweet.fromJson(doc));
        }
        return list;
      });
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> deleteComment(tweetId, commentId) async {
    try {
      await firestore
          .collection(tweetsCollection)
          .doc(tweetId)
          .collection(commentCollection)
          .doc(commentId)
          .delete();
    } catch (e) {
      CustomSnackBar.error(e.toString());
    }
  }
}
