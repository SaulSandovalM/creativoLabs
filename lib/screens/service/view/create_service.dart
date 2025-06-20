import 'package:creativolabs/core/widgets/back_buttons.dart';
import 'package:creativolabs/core/widgets/container.dart';
import 'package:creativolabs/screens/service/widget/main_create_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreateService extends StatelessWidget {
  const CreateService({super.key});

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
                    title: 'Servicios',
                    onPressed: () => context.go('/services'),
                    icon: Icons.arrow_back,
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Crear Servicio',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 30,
                    ),
                  ),
                ],
              ),
            ],
          ),
          MainCreateService(),
          SizedBox(height: 40),
        ],
      ),
    );
  }
}
