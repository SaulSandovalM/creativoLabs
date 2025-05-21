import 'package:creativolabs/core/widgets/container.dart';
import 'package:creativolabs/services/customers_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DetailCustomer extends StatelessWidget {
  final String? id;
  const DetailCustomer({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    if (id == null) {
      return const Center(child: Text('ID no válido'));
    }

    final customerService = CustomersService();

    return FutureBuilder<Map<String, dynamic>?>(
      future: customerService.getCustomerById(id!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('Cliente no encontrado'));
        }

        final customer = snapshot.data!;

        return MainContainer(
          child: Column(
            children: [
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      context.go('/customers');
                    },
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Clientes'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      elevation: 0,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      // Imagen de perfil
                      CircleAvatar(
                        radius: 35,
                        backgroundImage: NetworkImage(
                          'https://via.placeholder.com/150', // Aquí ponga su URL real o use AssetImage si la tiene local
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Nombre, estado y correo
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            customer['name'] ?? 'Sin nombre',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Chip(
                                label: const Text('Activo'),
                                backgroundColor: Colors.green.shade50,
                                avatar: const Icon(Icons.check_circle,
                                    color: Colors.teal, size: 18),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                labelStyle:
                                    const TextStyle(color: Colors.black87),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'miron.vitold@dominio.com',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Botón de acción
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.arrow_drop_down),
                    label: const Text('Acción'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFF6A5BFF), // Morado vibrante
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }
}
