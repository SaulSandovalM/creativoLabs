import 'package:creativolabs/core/widgets/container.dart';
import 'package:creativolabs/screens/sales/widget/main_create_sale.dart';
import 'package:flutter/material.dart';

class CreateSales extends StatelessWidget {
  const CreateSales({super.key});

  @override
  Widget build(BuildContext context) {
    return MainContainer(
      child: Column(
        children: [
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Crear Orden',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 30,
                ),
              ),
            ],
          ),
          MainCreateSale(),
          SizedBox(height: 40),
        ],
      ),
    );
  }
}
