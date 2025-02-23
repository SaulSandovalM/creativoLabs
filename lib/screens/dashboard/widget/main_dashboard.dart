import 'package:creativolabs/core/widgets/container.dart';
import 'package:flutter/material.dart';

class MainDashboard extends StatefulWidget {
  final double headerHeight;

  const MainDashboard({super.key, required this.headerHeight});

  @override
  MainDashboardState createState() => MainDashboardState();
}

class MainDashboardState extends State<MainDashboard> {
  @override
  Widget build(BuildContext context) {
    return const MainContainer(
      child: Text('data'),
    );
  }
}
