import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:freelancer/models/user.dart';
import 'package:freelancer/resourses/storage.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<MyUser> getuserDetails() async {
    User currentUser;
    _auth.authStateChanges().listen((User? user) async {
      if (user != null) {
        currentUser = user;
        // print(snap!.data());
      }
    });
    String token = _auth.currentUser!.uid;
    String? email = _auth.currentUser?.email;
    DocumentSnapshot snap =
        await _firestore.collection('users').doc(token).get();
    var snapshot = snap.data() as Map<String, dynamic>;

    return MyUser(
        email: email!,
        username: (snap.data() as Map<String, dynamic>)['username'],
        uid: (snap.data() as Map<String, dynamic>)['uid'],
        photoUrl: (snap.data() as Map<String, dynamic>)['photo'],
        bio: (snap.data() as Map<String, dynamic>)['bio'],
        followers: (snap.data() as Map<String, dynamic>)['followers'],
        following: (snap.data() as Map<String, dynamic>)['following']);
  }

  Future<String> signIn({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          file != null) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        String photoUrl =
            await storageFunc().uploadImage('profilePics', file, false);
        MyUser modelUser = MyUser(
            email: email,
            username: username,
            uid: cred.user!.uid,
            photoUrl: photoUrl,
            bio: bio,
            followers: [],
            following: []);
        _firestore.collection('users').doc(cred.user!.uid).set(
              modelUser.toJson(),
            );
        res = "Success";
      } else {
        res = "Fill in all the fields";
      }
    } catch (e) {
      res = e.toString();
      print(e);
    }
    return res;
  }

  Future<String> LogIn(
      {required String email, required String password}) async {
    String res = "";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        UserCredential cred = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "Success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (e) {
      res = e.toString();
      print(e);
    }
    return res;
  }

  Future<void> signout() async {
    await _auth.signOut();
  }
}
