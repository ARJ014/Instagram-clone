import 'package:flutter/material.dart';
import 'package:freelancer/models/user.dart';
import 'package:freelancer/provider/user_provider.dart';
import 'package:freelancer/utils/colors.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CommentCard extends StatelessWidget {
  final snap;
  const CommentCard({super.key, required this.snap});

  @override
  Widget build(BuildContext context) {
    MyUser user = Provider.of<UserProvider>(context).getUser;
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(snap['profilePic']),
              radius: 16,
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                        text: TextSpan(
                            style: const TextStyle(color: primaryColor),
                            children: [
                          TextSpan(
                              text: snap['name'],
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: " ${snap['text']}"),
                        ])),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        DateFormat.yMMMd().format(
                          snap['datePublished'].toDate(),
                        ),
                        style: const TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 12),
                      ),
                    )
                  ]),
            ))
          ],
        ));
  }
}
