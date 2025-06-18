import 'package:creativolabs/core/widgets/back_buttons.dart';
import 'package:creativolabs/core/widgets/container.dart';
import 'package:creativolabs/screens/customers/widget/main_create_customer.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BackButtons(
                    title: 'Clientes',
                    onPressed: () => context.go('/customers'),
                    icon: Icons.arrow_back,
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Crear Cliente',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 30,
                    ),
                  ),
                ],
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
