import 'package:creativolabs/screens/changepassword/widget/main_change_password.dart';
import 'package:flutter/material.dart';

class ChangePassword extends StatelessWidget {
  final String oobCode;
  const ChangePassword({super.key, required this.oobCode});

  @override
  Widget build(BuildContext context) {
    return MainChangePassword(
      headerHeight: 60,
      oobCode: oobCode,
    );
  }
}
