import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String comment;
  final String username;
  final String profilePic;
  final String uid;
  final List likes;
  final String commentId;
  final DateTime datePublished;

  Comment(
      {required this.comment,
      required this.username,
      required this.uid,
      required this.profilePic,
      required this.likes,
      required this.commentId,
      required this.datePublished});

  Map<String, dynamic> toJson() => {
        "username": username,
        "profilePic": profilePic,
        "uid": uid,
        "likes": likes,
        "commentId": commentId,
        "comment": comment,
        "datePublished": datePublished
      };

  static Comment fromJson(DocumentSnapshot snap) {
    final snapshot = snap.data() as Map<String, dynamic>;
    return Comment(
        comment: snapshot["comment"],
        username: snapshot["username"],
        profilePic: snapshot["profilePic"],
        uid: snapshot["uid"],
        likes: snapshot["likes"],
        commentId: snapshot["commentId"],
        datePublished: (snapshot["datePublished"] as Timestamp).toDate());
  }
}
