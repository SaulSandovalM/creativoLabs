import 'package:creativolabs/core/widgets/container.dart';
import 'package:creativolabs/screens/about/widget/main_about.dart';
import 'package:flutter/material.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainContainer(
      child: Column(
        children: [
          SizedBox(height: 40),
          MainAbout(),
          SizedBox(height: 40),
        ],
      ),
    );
  }
}
