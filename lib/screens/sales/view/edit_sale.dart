import 'package:creativolabs/api/sales_service.dart';
import 'package:creativolabs/core/widgets/back_buttons.dart';
import 'package:creativolabs/core/widgets/container.dart';
import 'package:creativolabs/providers/business_model.dart';
import 'package:creativolabs/screens/sales/widget/main_edit_sale.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class EditSale extends StatelessWidget {
  final String? orderId;

  const EditSale({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final businessModel = context.watch<BusinessModel>();

    if (businessModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final businessId = businessModel.businessId;

    // Validación de datos necesarios
    if (businessId == null || orderId == null) {
      return const Center(child: Text('ID de negocio o orden no válido'));
    }

    final salesService = SalesService();

    return FutureBuilder<Map<String, dynamic>?>(
      future: salesService.getOrderById(
        businessId: businessId,
        orderId: orderId!,
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

        final order = snapshot.data!;

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
                        title: 'Ordenes',
                        onPressed: () => context.go('/sales'),
                        icon: Icons.arrow_back,
                      ),
                      SizedBox(height: 30),
                      Text(
                        'Editar Orden',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 30,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              MainEditSale(order: order),
              SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }
}
