import 'package:creativolabs/core/widgets/container.dart';
import 'package:creativolabs/screens/dashboard/widget/main_dashboard.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainContainer(
      child: Column(
        children: [
          SizedBox(height: 40),
          MainDashboard(headerHeight: 60),
          SizedBox(height: 40),
        ],
      ),
    );
  }
}
