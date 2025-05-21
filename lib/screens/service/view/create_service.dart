import 'package:creativolabs/core/widgets/container.dart';
import 'package:creativolabs/screens/service/widget/main_create_service.dart';
import 'package:flutter/material.dart';

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
              Text(
                'Crear servicio',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 30,
                ),
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
