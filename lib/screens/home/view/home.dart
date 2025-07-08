import 'package:creativolabs/core/widgets/container.dart';
import 'package:creativolabs/screens/home/widget/first_section.dart';
import 'package:creativolabs/screens/home/widget/main_desktop.dart';
import 'package:creativolabs/screens/home/widget/second_section.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainContainer(
      child: Column(
        children: [
          MainDesktop(headerHeight: 60),
          FirstSection(),
          SecondSection(),
          SizedBox(height: 40),
        ],
      ),
    );
  }
}
