import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creativolabs/services/sales_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatDate(dynamic date) {
  if (date is Timestamp) {
    date = date.toDate();
  }
  return DateFormat('dd MMMM', 'es').format(date);
}

class MainSales extends StatefulWidget {
  final double headerHeight;

  const MainSales({super.key, required this.headerHeight});

  @override
  MainSalesState createState() => MainSalesState();
}

class MainSalesState extends State<MainSales> {
  final SalesService _salesService = SalesService();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: StreamBuilder<QuerySnapshot>(
        stream: _salesService.getSalesStreamByBusiness('bus_456'),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snapshot.data!.docs;
          final sales =
              docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
          return PaginatedDataTable(
            columns: const [
              DataColumn(label: Text('Fecha')),
              DataColumn(label: Text('Orden')),
              DataColumn(label: Text('Método de Pago')),
              DataColumn(label: Text('Cliente')),
              DataColumn(label: Text('Estado')),
              DataColumn(label: Text('')),
            ],
            source: _OrderDataSource(sales),
            rowsPerPage: 10,
          );
        },
      ),
    );
  }
}

class _OrderDataSource extends DataTableSource {
  final List<Map<String, dynamic>> sales;

  _OrderDataSource(this.sales);

  @override
  DataRow? getRow(int index) {
    if (index >= sales.length) return null;
    final order = sales[index];
    return DataRow(cells: [
      DataCell(Text(formatDate(order['createdAt']))),
      DataCell(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(order['orderNumber'] != null
                ? order['orderNumber'].toString()
                : 'Sin número'),
            Text(
              (order['serviceName'] +
                      ' - ' +
                      '\$${order['price'].toStringAsFixed(2)}' ??
                  'Sin servicio'),
              style: TextStyle(
                fontSize: 12,
                color: Color(0xff667085),
              ),
            ),
          ],
        ),
      ),
      DataCell(Text(order['paymentMethod'] ?? 'Sin método')),
      DataCell(
        Row(
          children: [
            Text(order['customerName'] ?? 'Sin cliente'),
          ],
        ),
      ),
      DataCell(
        Row(
          children: [
            Icon(
              order['status'] == 'Completado'
                  ? Icons.check_circle
                  : order['status'] == 'Pendiente'
                      ? Icons.hourglass_empty
                      : Icons.cancel,
              color: order['status'] == 'Completado'
                  ? Colors.green
                  : order['status'] == 'Pendiente'
                      ? Colors.orange
                      : Colors.red,
            ),
            const SizedBox(width: 8),
            Text(order['status'] ?? 'Sin estado'),
          ],
        ),
      ),
      DataCell(
        Icon(Icons.remove_red_eye_outlined, color: Colors.black),
      ),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => sales.length;

  @override
  int get selectedRowCount => 0;
}
