import 'package:creativolabs/core/widgets/container.dart';
import 'package:creativolabs/screens/customers/widget/main_create_customer.dart';
import 'package:flutter/material.dart';

class CreateCustomer extends StatelessWidget {
  const CreateCustomer({super.key});

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
          MainCreateCustomer(),
          SizedBox(height: 40),
        ],
      ),
    );
  }
}
