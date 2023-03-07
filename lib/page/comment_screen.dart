import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freelancer/models/user.dart';
import 'package:freelancer/provider/user_provider.dart';
import 'package:freelancer/resourses/firestore.dart';
import 'package:freelancer/utils/colors.dart';
import 'package:freelancer/widgets/comment_card.dart';
import 'package:provider/provider.dart';

import '../utils/utils.dart';

class CommentPage extends StatefulWidget {
  final snap;

  const CommentPage({super.key, required this.snap});

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  final TextEditingController _controller = TextEditingController();
  bool _isloading = false;

  post(String username, String uid, String url) async {
    try {
      setState(() {
        _isloading = true;
      });
      String res = await FirestoreFunc().postComment(
          widget.snap['postId'], _controller.text, uid, username, url);
      if (res == "success") {
        setState(() {
          _isloading = false;
          // _controller.dispose();
          _controller.text = "";
        });
        showSnackBar("Posted", context);
      } else {
        setState(() {
          _isloading = false;
          _controller.dispose();
        });
        showSnackBar(res, context);
      }
    } catch (e) {
      setState(() {
        _isloading = false;
      });
      showSnackBar(e.toString(), context);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MyUser user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text("Comments"),
        centerTitle: false,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.snap['postId'])
            .collection('comments')
            .orderBy('datePublished', descending: true)
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              return CommentCard(snap: snapshot.data!.docs[index]);
            },
          );
        },
      ),
      bottomNavigationBar: Container(
        margin:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        height: kToolbarHeight,
        padding: const EdgeInsets.only(left: 15, right: 8),
        child: Column(
          children: [
            _isloading
                ? const LinearProgressIndicator()
                : const Padding(padding: EdgeInsets.only(top: 0)),
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(user.photoUrl),
                  radius: 16,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 8),
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                          hintText: "Write a comment...",
                          border: InputBorder.none),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    post(user.username, user.uid, user.photoUrl);
                  },
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 8),
                      child: const Text(
                        "Post",
                        style: TextStyle(color: blueColor),
                      )),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
