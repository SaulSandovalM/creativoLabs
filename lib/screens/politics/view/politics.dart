import 'package:creativolabs/core/widgets/container.dart';
import 'package:creativolabs/screens/politics/widget/main_politics.dart';
import 'package:flutter/material.dart';

class Politics extends StatelessWidget {
  const Politics({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainContainer(
      child: Column(
        children: [
          SizedBox(height: 40),
          MainPolitics(),
          SizedBox(height: 40),
        ],
      ),
    );
  }
}
