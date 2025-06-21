import 'package:creativolabs/core/widgets/back_buttons.dart';
import 'package:creativolabs/core/widgets/container.dart';
import 'package:creativolabs/screens/createorder/widget/main_create_order.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Createorder extends StatelessWidget {
  final String serviceId;
  final String serviceName;
  final String servicePrice;

  const Createorder({
    super.key,
    required this.serviceId,
    required this.serviceName,
    required this.servicePrice,
  });

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
                    title: 'Crear Orden',
                    onPressed: () => context.go('/sales'),
                    icon: Icons.arrow_back,
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
          MainCreateOrder(
            serviceId: serviceId,
            serviceName: serviceName,
            servicePrice: servicePrice,
          ),
          SizedBox(height: 40),
        ],
      ),
    );
  }
}
