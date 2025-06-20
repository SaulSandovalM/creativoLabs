import 'package:creativolabs/core/widgets/container.dart';
import 'package:creativolabs/screens/terms/widget/main_terms.dart';
import 'package:flutter/material.dart';

class Terms extends StatelessWidget {
  const Terms({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainContainer(
      child: Column(
        children: [
          SizedBox(height: 40),
          MainTerms(),
          SizedBox(height: 40),
        ],
      ),
    );
  }
}
