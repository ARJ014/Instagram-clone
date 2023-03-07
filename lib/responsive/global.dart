import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freelancer/page/add_new_post.dart';
import 'package:freelancer/page/homescreen.dart';
import 'package:freelancer/page/search_screen.dart';
import 'package:freelancer/page/userinfo.dart';

int maxscreenSize = 600;
var homescreenItems = [
  const HomeScreen(),
  const SearchScreen(),
  const AddPost(),
  const Text("4"),
  UserScreen(uid: FirebaseAuth.instance.currentUser!.uid)
];
