import 'package:creativolabs/core/widgets/container.dart';
import 'package:creativolabs/screens/dashboard/widget/overall.dart';
import 'package:creativolabs/screens/dashboard/widget/overview_statistic_widget.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainContainer(
      child: Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: Row(
                  children: [
                    Column(
                      children: [
                        SizedBox(height: 100),
                        Overall(),
                        OverviewStatistic(),
                      ],
                    ),
                    // SizedBox(
                    //   width: context.width * 0.023,
                    // ),
                    // const StockWidget(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      // child: Column(
      //   children: [
      //     SizedBox(height: 40),
      //     Overall(),
      //     SizedBox(height: 40),
      //   ],
      // ),
    );
  }
}
