import 'package:creativolabs/core/widgets/container.dart';
import 'package:creativolabs/screens/service/widget/main_edit_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EditService extends StatelessWidget {
  final String serviceId;

  const EditService({super.key, required this.serviceId});

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
                      context.go('/services');
                    },
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Servicios'),
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
          MainEditService(serviceId: serviceId),
          SizedBox(height: 40),
        ],
      ),
    );
  }
}
