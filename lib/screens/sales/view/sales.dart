import 'package:creativolabs/core/widgets/container.dart';
import 'package:creativolabs/screens/sales/widget/main_sales.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Sales extends StatelessWidget {
  const Sales({super.key});

  @override
  Widget build(BuildContext context) {
    return MainContainer(
      child: Column(
        children: [
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Órdenes',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 30,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  context.go('/create-order');
                },
                icon: Icon(Icons.add),
                label: Text('Agregar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ],
          ),
          MainSales(headerHeight: 60),
          SizedBox(height: 40),
        ],
      ),
    );
  }
}
