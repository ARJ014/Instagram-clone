import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser {
  final String email;
  final String username;
  final String uid;
  final String photoUrl;
  final String bio;
  final List followers;
  final List following;

  const MyUser(
      {required this.email,
      required this.username,
      required this.uid,
      required this.photoUrl,
      required this.bio,
      required this.followers,
      required this.following});

  Map<String, dynamic> toJson() => {
        'email': email,
        'username': username,
        'uid': uid,
        'bio': bio,
        'followers': followers,
        'following': following,
        'photo': photoUrl,
      };

  static MyUser fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return MyUser(
        email: snapshot["email"],
        username: snapshot['username'],
        uid: snapshot['uid'],
        photoUrl: snapshot['photo'],
        bio: snapshot['bio'],
        followers: snapshot['followers'],
        following: snapshot['following']);
  }
}
