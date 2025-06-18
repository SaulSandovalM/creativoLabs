import 'package:creativolabs/core/widgets/paginated_table.dart';
import 'package:flutter/material.dart';
import 'package:creativolabs/api/customers_service.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:creativolabs/providers/business_model.dart';

class MainCustomers extends StatelessWidget {
  final double headerHeight;
  const MainCustomers({super.key, required this.headerHeight});

  @override
  Widget build(BuildContext context) {
    final businessModel = context.watch<BusinessModel>();
    final businessId = businessModel.businessId;

    if (businessModel.isLoading || businessId == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final customersService = CustomersService();

    return SizedBox(
      width: double.infinity,
      child: PaginatedTable<Map<String, dynamic>>(
        stream: customersService.getCustomersStreamByBusiness(businessId).map(
            (snapshot) => snapshot.docs
                .map((doc) => doc.data() as Map<String, dynamic>)
                .toList()),
        columns: const [
          DataColumn(label: Text('Nombre')),
          DataColumn(label: Text('Telefono')),
          DataColumn(label: Text('Correo')),
          DataColumn(label: Text('Creado en')),
          DataColumn(label: Text('Estatus')),
        ],
        buildRow: (data, index) {
          String formatDate(dynamic date) {
            if (date is Timestamp) date = date.toDate();
            return DateFormat('dd/MM/yyyy', 'es').format(date);
          }

          return DataRow(cells: [
            DataCell(
              Text(data['name'] ?? 'Sin nombre'),
              onTap: () => context.go('/detail-customer/${data['id']}'),
            ),
            DataCell(Text(data['phoneNumber']?.toString() ?? 'Sin número')),
            DataCell(Text(data['email'] ?? 'Sin correo')),
            DataCell(
              Text(data['createdAt'] != null
                  ? formatDate(data['createdAt'])
                  : 'Sin fecha'),
            ),
            DataCell(Row(
              children: [
                Icon(
                  data['status'] == 'Activo'
                      ? Icons.check_circle
                      : data['status'] == 'Bloqueado'
                          ? Icons.hourglass_empty
                          : Icons.cancel,
                  color: data['status'] == 'Activo'
                      ? Colors.green
                      : data['status'] == 'Bloqueado'
                          ? Colors.orange
                          : Colors.red,
                ),
                const SizedBox(width: 8),
                Text(data['status'] ?? 'Sin estado'),
              ],
            )),
          ]);
        },
      ),
    );
  }
}
