import 'package:creativolabs/core/widgets/container.dart';
import 'package:creativolabs/screens/profile/widget/main_profile.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainContainer(
      child: Column(
        children: [
          SizedBox(height: 40),
          MainProfile(headerHeight: 60),
          SizedBox(height: 40),
        ],
      ),
    );
  }
}
