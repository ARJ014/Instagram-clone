import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String uid;
  final String description;
  final String postId;
  final String username;
  final datepublished;
  final String postUrl;
  final String profImage;
  final likes;
  Post(
      {required this.uid,
      required this.description,
      required this.postId,
      required this.username,
      required this.datepublished,
      required this.postUrl,
      required this.profImage,
      required this.likes});

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "description": description,
      "postId": postId,
      "username": username,
      "datepublished": datepublished,
      "postUrl": postUrl,
      "profImage": profImage,
      "likes": likes
    };
  }

  static PostformSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Post(
        uid: snapshot["uid"],
        description: snapshot["description"],
        postId: snapshot["postId"],
        username: snapshot["username"],
        datepublished: snapshot['datepublished'],
        postUrl: snapshot['postUrl'],
        profImage: snapshot['profImage'],
        likes: snapshot["likes"]);
  }
}
