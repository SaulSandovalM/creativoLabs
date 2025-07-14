import 'package:creativolabs/core/widgets/container.dart';
import 'package:creativolabs/screens/signup/widget/main_signup.dart';
import 'package:flutter/material.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainContainer(
      child: Column(
        children: [
          MainSignup(headerHeight: 60),
          SizedBox(height: 40),
        ],
      ),
    );
  }
}
