import 'package:creativolabs/core/widgets/button.dart';
import 'package:creativolabs/core/widgets/container.dart';
import 'package:creativolabs/screens/service/widget/main_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Service extends StatelessWidget {
  const Service({super.key});

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
                'Servicios',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 30,
                ),
              ),
              Button(
                title: 'Agregar',
                onPressed: () => context.go('/create-service'),
                icon: Icons.add,
              ),
            ],
          ),
          SizedBox(height: 20),
          MainService(headerHeight: 60),
          SizedBox(height: 40),
        ],
      ),
    );
  }
}
