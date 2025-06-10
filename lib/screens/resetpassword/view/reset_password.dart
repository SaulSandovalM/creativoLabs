import 'package:creativolabs/core/widgets/container.dart';
import 'package:creativolabs/screens/resetpassword/widget/main_reset_password.dart';
import 'package:flutter/material.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainContainer(
      child: Column(
        children: [
          MainResetPassword(headerHeight: 60),
          SizedBox(height: 40),
        ],
      ),
    );
  }
}
