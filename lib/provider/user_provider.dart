import 'package:flutter/material.dart';
import 'package:freelancer/models/user.dart';
import 'package:freelancer/resourses/auth.dart';

class UserProvider extends ChangeNotifier {
  MyUser? _user;
  final Auth _auth = Auth();
  MyUser get getUser => _user!;

  Future<void> refreshUser() async {
    MyUser user = await _auth.getuserDetails();
    _user = user;
    notifyListeners();
  }
}
