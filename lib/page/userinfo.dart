import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freelancer/resourses/auth.dart';
import 'package:freelancer/resourses/firestore.dart';
import 'package:freelancer/utils/colors.dart';
import 'package:freelancer/utils/utils.dart';
import 'package:freelancer/widgets/follow.dart';

class UserScreen extends StatefulWidget {
  String uid;
  UserScreen({super.key, required this.uid});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  var userdata = {};
  int posts = 0;
  int followers = 0;
  int following = 0;
  bool isfollowing = false;
  bool isloading = false;

  @override
  void initState() {
    super.initState();
    getdata();
  }

  getdata() async {
    try {
      setState(() {
        isloading = true;
      });
      var usersnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      userdata = usersnap.data()!;

      var postsnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: widget.uid)
          .get();
      posts = postsnap.docs.length;
      followers = userdata['followers'].length;
      following = userdata['following'].length;
      isfollowing = userdata['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);

      setState(() {});
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
    setState(() {
      isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isloading
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            backgroundColor: mobileBackgroundColor,
            appBar: AppBar(
              title: Text(userdata['username']),
              backgroundColor: mobileBackgroundColor,
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage(userdata['photo']),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    ColumnMaker(value: posts, label: "Posts"),
                                    ColumnMaker(
                                        value: followers, label: "Followers"),
                                    ColumnMaker(
                                        value: following, label: "Following")
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    (widget.uid ==
                                            FirebaseAuth
                                                .instance.currentUser!.uid)
                                        ? FollowButton(
                                            backgroundcolor:
                                                mobileBackgroundColor,
                                            bordercolor: Colors.grey,
                                            text: "Sign Out",
                                            textcolor: primaryColor,
                                            func: () async {
                                              await Auth().signout();
                                            },
                                          )
                                        : isfollowing
                                            ? FollowButton(
                                                backgroundcolor: Colors.white,
                                                bordercolor: Colors.grey,
                                                text: "Unfollow",
                                                textcolor: Colors.black,
                                                func: () async {
                                                  setState(() {
                                                    isfollowing = false;
                                                    followers--;
                                                  });
                                                  await FirestoreFunc().follow(
                                                      FirebaseAuth.instance
                                                          .currentUser!.uid,
                                                      widget.uid);
                                                },
                                              )
                                            : FollowButton(
                                                backgroundcolor: Colors.blue,
                                                bordercolor: Colors.blue,
                                                text: "Follow",
                                                textcolor: primaryColor,
                                                func: () async {
                                                  setState(() {
                                                    isfollowing = true;
                                                    followers++;
                                                  });
                                                  await FirestoreFunc().follow(
                                                      FirebaseAuth.instance
                                                          .currentUser!.uid,
                                                      widget.uid);
                                                },
                                              )
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 15),
                        child: Text(
                          userdata['username'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(userdata['bio']),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('posts')
                      .where('uid', isEqualTo: widget.uid)
                      .get(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return GridView.builder(
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 1.5,
                              childAspectRatio: 1),
                      itemCount: (snapshot.data! as dynamic).docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        DocumentSnapshot snap =
                            (snapshot.data! as dynamic).docs[index];
                        return Container(
                          child: Image(
                            image: NetworkImage(snap['postUrl']),
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
  }
}

class ColumnMaker extends StatelessWidget {
  int value;
  String label;
  ColumnMaker({
    required this.value,
    required this.label,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(label,
              style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                  color: Colors.grey)),
        )
      ],
    );
  }
}
