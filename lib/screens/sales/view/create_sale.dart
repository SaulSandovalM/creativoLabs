import 'package:creativolabs/core/widgets/container.dart';
import 'package:creativolabs/screens/sales/widget/main_create_sale.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      context.go('/sales');
                    },
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Ordenes'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      elevation: 0,
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Crear Orden',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 30,
                    ),
                  ),
                ],
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
