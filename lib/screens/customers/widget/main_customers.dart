import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creativolabs/services/customers_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

String formatDate(dynamic date) {
  if (date is Timestamp) {
    date = date.toDate();
  }
  return DateFormat('dd MMMM', 'es').format(date);
}

class MainCustomers extends StatefulWidget {
  final double headerHeight;

  const MainCustomers({super.key, required this.headerHeight});

  @override
  MainCustomersState createState() => MainCustomersState();
}

class MainCustomersState extends State<MainCustomers> {
  final CustomersService _customersService = CustomersService();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: StreamBuilder<QuerySnapshot>(
        stream: _customersService.getCustomersStreamByBusiness('bus_456'),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snapshot.data!.docs;
          final customers = docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            data['id'] = doc.id;
            return data;
          }).toList();
          return PaginatedDataTable(
            columns: const [
              DataColumn(label: Text('Nombre')),
              DataColumn(label: Text('Telefono')),
              DataColumn(label: Text('Correo')),
              DataColumn(label: Text('Creado en')),
              DataColumn(label: Text('Estatus')),
            ],
            source: _CustomersDataSource(customers, context),
            rowsPerPage: 10,
          );
        },
      ),
    );
  }
}

class _CustomersDataSource extends DataTableSource {
  final List<Map<String, dynamic>> customer;
  final BuildContext context;

  _CustomersDataSource(this.customer, this.context);

  String formatDate(dynamic date) {
    if (date is Timestamp) {
      date = date.toDate();
    }
    return DateFormat('dd/MM/yyyy', 'es').format(date);
  }

  @override
  DataRow? getRow(int index) {
    if (index >= customer.length) return null;
    final order = customer[index];
    return DataRow(cells: [
      DataCell(
        Text(order['name'] ?? 'Sin nombre'),
        onTap: () {
          context.go('/detail-customer/${order['id']}');
        },
      ),
      DataCell(
        Text(order['phoneNumber'] != null
            ? order['phoneNumber'].toString()
            : 'Sin numero'),
      ),
      DataCell(Text(order['email'] ?? 'Sin correo')),
      DataCell(
        Text(order['createdAt'] != null
            ? formatDate(order['createdAt'])
            : 'Sin fecha'),
      ),
      DataCell(
        Row(
          children: [
            Icon(
              order['status'] == 'Activo'
                  ? Icons.check_circle
                  : order['status'] == 'Bloqueado'
                      ? Icons.hourglass_empty
                      : Icons.cancel,
              color: order['status'] == 'Activo'
                  ? Colors.green
                  : order['status'] == 'Bloqueado'
                      ? Colors.orange
                      : Colors.red,
            ),
            const SizedBox(width: 8),
            Text(order['status'] ?? 'Sin estado'),
          ],
        ),
      ),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => customer.length;

  @override
  int get selectedRowCount => 0;
}
