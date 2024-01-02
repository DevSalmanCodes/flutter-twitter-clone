import 'package:cloud_firestore/cloud_firestore.dart';

class Tweet {
  final String description;
  final String uid;
  final String username;
  final List likes;
  final String tweetId;
  final DateTime datePublished;
  final String? photoUrl;
  final String profImage;
  final List comments;

  Tweet({
    required this.description,
    required this.uid,
    required this.username,
    required this.likes,
    required this.tweetId,
    required this.datePublished,
    this.photoUrl,
    required this.profImage,
    required this.comments,
  });

  Map<String, dynamic> toJson() => {
        'description': description,
        'uid': uid,
        'username': username,
        'likes': likes,
        'tweetId': tweetId,
        'datePublished': datePublished,
        'photoUrl': photoUrl,
        'profImage': profImage,
        'comments': comments
      };

  static Tweet fromJson(DocumentSnapshot snap) {
    final snapshot = snap.data() as Map<String, dynamic>;
    return Tweet(
        description: snapshot["description"],
        uid: snapshot["uid"],
        username: snapshot["username"],
        likes: snapshot["likes"],
        tweetId: snapshot["tweetId"],
        datePublished: (snapshot["datePublished"] as Timestamp).toDate(),
        photoUrl: snapshot["photoUrl"],
        profImage: snapshot["profImage"],
        comments: snapshot["comments"]);
  }
}
