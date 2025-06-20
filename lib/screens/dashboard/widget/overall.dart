import 'package:creativolabs/screens/dashboard/widget/custom_button.dart';
import 'package:creativolabs/screens/dashboard/widget/outline_button.dart';
import 'package:creativolabs/screens/dashboard/widget/total_widget.dart';
import 'package:flutter/material.dart';

class Overall extends StatelessWidget {
  const Overall({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      transform: Matrix4.translationValues(0, -90, 0),
      width: MediaQuery.of(context).size.width * 0.65,
      height: MediaQuery.of(context).size.height * 0.24,
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 22.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Text(
                'Descripción general',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const Spacer(),
              CustomOutlineButton(
                width: MediaQuery.of(context).size.width * 0.08,
                title: 'Withdraw',
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.015,
              ),
              CustomButton(
                width: MediaQuery.of(context).size.width * 0.08,
                title: 'Deposit',
                isIconButton: true,
              ),
            ],
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TotalWidget(
                title: 'Balance',
              ),
              TotalWidget(
                title: 'Invertido',
              ),
              TotalWidget(
                title: 'Ganancias',
              ),
              TotalWidget(
                title: 'Perdidas',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
