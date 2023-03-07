import 'package:flutter/material.dart';
import 'package:freelancer/provider/user_provider.dart';
import 'package:freelancer/responsive/global.dart';
import 'package:provider/provider.dart';

class Responsive_layout extends StatefulWidget {
  final Widget webScreenLayout;
  final Widget phoneScreenLayout;
  const Responsive_layout(this.phoneScreenLayout, this.webScreenLayout,
      {super.key});

  @override
  State<Responsive_layout> createState() => _Responsive_layoutState();
}

class _Responsive_layoutState extends State<Responsive_layout> {
  @override
  void initState() {
    super.initState();
    adduser();
  }

  adduser() async {
    UserProvider userProvider = Provider.of(context, listen: false);
    await userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth > maxscreenSize) {
          return widget.webScreenLayout;
        }
        return widget.phoneScreenLayout;
      },
    );
  }
}
