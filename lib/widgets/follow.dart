import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  final Function()? func;
  final Color backgroundcolor;
  final Color bordercolor;
  final Color textcolor;
  final String text;
  const FollowButton(
      {this.func,
      required this.backgroundcolor,
      required this.bordercolor,
      required this.text,
      required this.textcolor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 2),
      child: TextButton(
        onPressed: func,
        child: Container(
          height: 27,
          width: 250,
          decoration: BoxDecoration(
              border: Border.all(color: bordercolor),
              color: backgroundcolor,
              borderRadius: BorderRadius.circular(5)),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(color: textcolor, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
