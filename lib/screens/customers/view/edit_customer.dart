import 'package:creativolabs/api/customers_service.dart';
import 'package:creativolabs/core/widgets/back_buttons.dart';
import 'package:creativolabs/core/widgets/container.dart';
import 'package:creativolabs/providers/business_model.dart';
import 'package:creativolabs/screens/customers/widget/main_edit_customer.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class EditCustomer extends StatelessWidget {
  final String? customerId;

  const EditCustomer({super.key, required this.customerId});

  @override
  Widget build(BuildContext context) {
    final businessModel = context.watch<BusinessModel>();

    // Mostrar cargando mientras el modelo está en proceso
    if (businessModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final businessId = businessModel.businessId;

    // Validación de datos necesarios
    if (businessId == null || customerId == null) {
      return const Center(child: Text('ID de negocio o cliente no válido'));
    }

    final customerService = CustomersService();

    return FutureBuilder<Map<String, dynamic>?>(
      future: customerService.getCustomerById(
        businessId: businessId,
        customerId: customerId!,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('Cliente no encontrado'));
        }

        final customer = snapshot.data!;

        return MainContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              BackButtons(
                title: 'Clientes',
                onPressed: () => context.go('/customers'),
                icon: Icons.arrow_back,
              ),
              const SizedBox(height: 30),
              const Text(
                'Editar Cliente',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 30,
                ),
              ),
              const SizedBox(height: 20),
              MainEditCustomer(customer: customer),
              const SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }
}
