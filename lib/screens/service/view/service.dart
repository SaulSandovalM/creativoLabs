import 'package:creativolabs/core/widgets/container.dart';
import 'package:creativolabs/screens/service/widget/main_service.dart';
import 'package:flutter/material.dart';

class Service extends StatelessWidget {
  const Service({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainContainer(
      child: Column(
        children: [
          SizedBox(height: 40),
          MainService(headerHeight: 60),
          SizedBox(height: 40),
        ],
      ),
    );
  }
}
