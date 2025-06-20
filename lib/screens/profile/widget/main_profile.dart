import 'package:creativolabs/core/widgets/container.dart';
import 'package:flutter/material.dart';

class MainProfile extends StatefulWidget {
  final double headerHeight;

  const MainProfile({super.key, required this.headerHeight});

  @override
  MainProfileState createState() => MainProfileState();
}

class MainProfileState extends State<MainProfile> {
  @override
  Widget build(BuildContext context) {
    return const MainContainer(
      child: Text('data'),
    );
  }
}
