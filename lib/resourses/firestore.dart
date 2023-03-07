import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:freelancer/models/posts.dart';
import 'package:freelancer/resourses/storage.dart';
import 'package:uuid/uuid.dart';

class FirestoreFunc {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> post(String uid, String description, Uint8List file,
      String username, String profImage) async {
    String res = "";
    try {
      if (uid.isNotEmpty || description.isNotEmpty || file != null) {
        String postUrl = await storageFunc().uploadImage('post', file, true);
        String postId = const Uuid().v1();
        Post newpost = Post(
            uid: uid,
            description: description,
            postId: postId,
            username: username,
            datepublished: DateTime.now(),
            postUrl: postUrl,
            profImage: profImage,
            likes: []);
        _firestore.collection("posts").doc(postId).set(newpost.toJson());
        res = "success";
      } else {
        res = "fill all the fields";
      }
    } catch (e) {
      res = e.toString();
      print(res);
    }
    return res;
  }

  Future<void> onLike(String uid, String postId, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          "likes": FieldValue.arrayRemove([uid])
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          "likes": FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> postComment(String postId, String text, String uid,
      String name, String profilePic) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        // if the likes list contains the user uid, we need to remove it
        String commentId = const Uuid().v1();
        _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
        res = 'success';
      } else {
        res = "Please enter text";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> deletePost(String postId) async {
    String res = "some error";
    try {
      await _firestore.collection('posts').doc(postId).delete();
      res = "success";
    } catch (e) {
      print(e.toString());
      res = e.toString();
    }
    return res;
  }

  Future<void> follow(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];
      if (following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });
        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });
        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
