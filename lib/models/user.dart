import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String username;
  final List followers;
  final List following;
  final String password;
  final String bio;
  String profilePic = '';
  final String uid;

  User({
    required this.email,
    required this.username,
    required this.followers,
    required this.following,
    required this.password,
    required this.bio,
    required this.profilePic,
    required this.uid,
  });

  Map<String, dynamic> toJson() => {
        "email": email,
        "username": username,
        "followers": followers,
        "following": following,
        "password": password,
        "bio": bio,
        "profilePic": profilePic,
        "uid": uid
      };
  static User fromJson(DocumentSnapshot snap) {
    final snapshot = snap.data() as Map<String, dynamic>;
    return User(
        email: snapshot["email"],
        username: snapshot["username"],
        followers: snapshot["followers"],
        following: snapshot["following"],
        password: snapshot["password"],
        bio: snapshot["bio"],
        profilePic: snapshot["profilePic"],
        uid: snapshot["uid"]);
  }
}
