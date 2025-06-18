import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creativolabs/api/sales_service.dart';
import 'package:creativolabs/core/widgets/paginated_table.dart';
import 'package:creativolabs/providers/business_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
  State<MainSales> createState() => _MainSalesState();
}

class _MainSalesState extends State<MainSales> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final businessModel = Provider.of<BusinessModel>(context, listen: false);
      if (businessModel.businessId == null) {
        businessModel.fetchBusinessId();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final businessModel = context.watch<BusinessModel>();
    final businessId = businessModel.businessId;

    if (businessModel.isLoading || businessId == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final salesService = SalesService();

    return SizedBox(
      width: double.infinity,
      child: PaginatedTable<Map<String, dynamic>>(
        stream: salesService
            .getSalesStreamByBusiness(businessId)
            .map((snapshot) => snapshot.docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  data['id'] = doc.id;
                  return data;
                }).toList()),
        columns: const [
          DataColumn(label: Text('Fecha')),
          DataColumn(label: Text('Orden')),
          DataColumn(label: Text('Método de Pago')),
          DataColumn(label: Text('Cliente')),
          DataColumn(label: Text('Estado')),
          DataColumn(label: Text('')),
        ],
        buildRow: (data, index) {
          return DataRow(
            cells: [
              DataCell(Text(formatDate(data['createdAt']))),
              DataCell(
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(data['orderNumber']?.toString() ?? 'Sin número'),
                    Text(
                      '${data['service']} - \$${(data['price'] ?? 0).toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xff667085),
                      ),
                    ),
                  ],
                ),
              ),
              DataCell(Text(data['paymentMethod'] ?? 'Sin método')),
              DataCell(Text(data['customerName'] ?? 'Sin cliente')),
              DataCell(
                Row(
                  children: [
                    Icon(
                      data['status'] == 'Completado'
                          ? Icons.check_circle
                          : data['status'] == 'Pendiente'
                              ? Icons.hourglass_empty
                              : Icons.cancel,
                      color: data['status'] == 'Completado'
                          ? Colors.green
                          : data['status'] == 'Pendiente'
                              ? Colors.orange
                              : Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Text(data['status'] ?? 'Sin estado'),
                  ],
                ),
              ),
              DataCell(
                Icon(Icons.remove_red_eye_outlined, color: Colors.black),
              ),
            ],
          );
        },
      ),
    );
  }
}
