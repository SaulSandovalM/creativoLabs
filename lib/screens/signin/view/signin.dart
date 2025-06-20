import 'package:creativolabs/core/widgets/container.dart';
import 'package:creativolabs/screens/signin/widget/main_signin.dart';
import 'package:flutter/material.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainContainer(
      child: Column(
        children: [
          MainSignIn(headerHeight: 60),
          SizedBox(height: 40),
        ],
      ),
    );
  }
}
