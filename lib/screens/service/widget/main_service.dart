import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creativolabs/services/service_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatDate(dynamic date) {
  if (date is Timestamp) {
    date = date.toDate();
  }
  return DateFormat('dd MMMM', 'es').format(date);
}

class MainService extends StatefulWidget {
  final double headerHeight;

  const MainService({super.key, required this.headerHeight});

  @override
  MainServiceState createState() => MainServiceState();
}

class MainServiceState extends State<MainService> {
  final ServiceService _serviceService = ServiceService();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: StreamBuilder<QuerySnapshot>(
        stream: _serviceService.getServiceStreamByBusiness('bus_456'),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snapshot.data!.docs;
          final services =
              docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
          return PaginatedDataTable(
            columns: const [
              DataColumn(label: Text('Servicio')),
              DataColumn(label: Text('Precio')),
              DataColumn(label: Text('')),
            ],
            source: _OrderDataSource(services),
            rowsPerPage: 10,
          );
        },
      ),
    );
  }
}

class _OrderDataSource extends DataTableSource {
  final List<Map<String, dynamic>> services;

  _OrderDataSource(this.services);

  @override
  DataRow? getRow(int index) {
    if (index >= services.length) return null;
    final order = services[index];
    return DataRow(cells: [
      DataCell(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(order['name'] ?? 'Sin nombre'),
          ],
        ),
      ),
      DataCell(
        Text(
          order['price'] != null
              ? '\$${order['price'].toStringAsFixed(2)}'
              : 'Sin precio',
          style: TextStyle(
            fontSize: 12,
            color: Color(0xff667085),
          ),
        ),
      ),
      DataCell(
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(Icons.edit, color: Colors.green),
            SizedBox(width: 10),
            Icon(Icons.delete, color: Colors.red),
          ],
        ),
      ),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => services.length;

  @override
  int get selectedRowCount => 0;
}
