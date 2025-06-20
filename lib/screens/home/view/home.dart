import 'package:creativolabs/core/widgets/container.dart';
import 'package:creativolabs/screens/home/widget/main_desktop.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainContainer(
      child: Column(
        children: [
          MainDesktop(headerHeight: 60),
          // FirstSection(),
          SizedBox(height: 40),
        ],
      ),
    );
  }
}
