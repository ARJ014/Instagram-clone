import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freelancer/models/user.dart';
import 'package:freelancer/page/comment_screen.dart';
import 'package:freelancer/provider/user_provider.dart';
import 'package:freelancer/resourses/firestore.dart';
import 'package:freelancer/utils/colors.dart';
import 'package:freelancer/utils/utils.dart';
import 'package:freelancer/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({super.key, required this.snap});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isAnimating = false;
  int commentlen = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getcomments();
  }

  getcomments() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();
      setState(() {
        commentlen = snap.docs.length;
      });
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    MyUser user = Provider.of<UserProvider>(context).getUser;
    return Container(
      color: mobileBackgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 10).copyWith(bottom: 14),
      child: Column(children: [
        //
        // ! Header Section

        Container(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
              .copyWith(right: 0),
          child: Row(children: [
            CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(widget.snap['profImage']),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.snap['username'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )
                    ]),
              ),
            ),
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => Dialog(
                            child: ListView(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              shrinkWrap: true,
                              children: ['Delete']
                                  .map((e) => InkWell(
                                        onTap: () {
                                          FirestoreFunc().deletePost(
                                              widget.snap['postId']);
                                          Navigator.of(context).pop();
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12, horizontal: 16),
                                          child: Text(e),
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ));
                },
                icon: const Icon(Icons.more_vert))
          ]),
        ),

        // ! Image Section
        GestureDetector(
          onDoubleTap: () async {
            await FirestoreFunc()
                .onLike(user.uid, widget.snap['postId'], widget.snap['likes']);
            setState(() {
              isAnimating = true;
            });
          },
          child: Stack(alignment: Alignment.center, children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.35,
              width: double.infinity,
              child: Image.network(widget.snap['postUrl'], fit: BoxFit.cover),
            ),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: isAnimating ? 0.5 : 0,
              child: LikeAnimation(
                isAnimating: isAnimating,
                duration: const Duration(milliseconds: 400),
                onEnd: () {
                  setState(() {
                    isAnimating = false;
                  });
                },
                child: const Icon(
                  Icons.favorite,
                  color: primaryColor,
                  size: 100,
                ),
              ),
            )
          ]),
        ),

        // ! Interaction Bar

        Row(
          children: [
            LikeAnimation(
              isAnimating: widget.snap['likes'].contains(user.uid),
              smallLike: true,
              child: IconButton(
                  onPressed: () async {
                    await FirestoreFunc().onLike(
                        user.uid, widget.snap['postId'], widget.snap['likes']);
                  },
                  icon: widget.snap['likes'].contains(user.uid)
                      ? const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : const Icon(Icons.favorite_border)),
            ),
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => CommentPage(
                            snap: widget.snap,
                          ))));
                },
                icon: const Icon(
                  Icons.comment_outlined,
                )),
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.send,
                )),
            Expanded(
                child: Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.bookmark_border),
              ),
            ))
          ],
        ),

        // ! Comments and description

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DefaultTextStyle(
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2!
                      .copyWith(fontWeight: FontWeight.bold),
                  child: Text(
                    "${widget.snap['likes'].length} Likes",
                    style: Theme.of(context).textTheme.bodyText2,
                  )),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 8),
                child: RichText(
                  text: TextSpan(
                      style: const TextStyle(color: primaryColor),
                      children: [
                        TextSpan(
                            text: widget.snap['username'],
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: "  ${widget.snap['description']}")
                      ]),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => CommentPage(
                            snap: widget.snap,
                          ))));
                },
                child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8).copyWith(),
                    child: Text(
                      "View all $commentlen comments",
                      style:
                          const TextStyle(fontSize: 14, color: secondaryColor),
                    )),
              ),
              Container(
                  child: Text(
                (DateFormat.yMMMd()
                    .format(widget.snap['datepublished'].toDate())),
                style: const TextStyle(fontSize: 14, color: secondaryColor),
              ))
            ],
          ),
        )
      ]),
    );
  }
}
