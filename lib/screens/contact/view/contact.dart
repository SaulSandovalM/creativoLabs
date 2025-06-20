import 'package:creativolabs/core/widgets/container.dart';
import 'package:creativolabs/screens/contact/widget/answer.dart';
import 'package:creativolabs/screens/contact/widget/location.dart';
import 'package:creativolabs/screens/contact/widget/main_contact.dart';
import 'package:flutter/material.dart';

class Contact extends StatelessWidget {
  const Contact({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainContainer(
      child: Column(
        children: [
          MainContact(headerHeight: 60),
          SizedBox(height: 40),
          Location(),
          SizedBox(height: 40),
          Answer(),
          SizedBox(height: 40),
        ],
      ),
    );
  }
}
