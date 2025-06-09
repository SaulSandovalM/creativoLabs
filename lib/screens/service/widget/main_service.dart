import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creativolabs/api/service_service.dart';
import 'package:creativolabs/providers/business_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

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

    final serviceService = ServiceService();

    return SizedBox(
      width: double.infinity,
      child: StreamBuilder<QuerySnapshot>(
        stream: serviceService.getServiceStreamByBusiness(businessId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No hay información'));
          }
          final docs = snapshot.data!.docs;
          final services = docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            data['id'] = doc.id;
            return data;
          }).toList();
          return PaginatedDataTable(
            columns: const [
              DataColumn(label: Text('Servicio')),
              DataColumn(label: Text('Precio')),
              DataColumn(label: Text('Descripción')),
              DataColumn(label: Text('Categoría')),
              DataColumn(label: Text('')),
            ],
            source:
                _OrderDataSource(context, services, businessId, serviceService),
            rowsPerPage: 10,
          );
        },
      ),
    );
  }
}

class _OrderDataSource extends DataTableSource {
  final BuildContext context;
  final List<Map<String, dynamic>> services;
  final String businessId;
  final ServiceService serviceService;

  _OrderDataSource(
      this.context, this.services, this.businessId, this.serviceService);

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
              ? '\$${order['price'].toString()}'
              : 'Sin precio',
          style: TextStyle(
            fontSize: 12,
            color: Color(0xff667085),
          ),
        ),
      ),
      DataCell(
        Text(
          order['description'] != null
              ? order['description'].toString()
              : 'Sin precio',
          style: TextStyle(
            fontSize: 12,
            color: Color(0xff667085),
          ),
        ),
      ),
      DataCell(
        Text(
          order['category'] != null && order['category'] is List
              ? (order['category'] as List).join(', ')
              : (order['category']?.toString() ?? 'Sin categoría'),
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xff667085),
          ),
        ),
      ),
      DataCell(
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
              onTap: () {
                context.go('/edit-service/${order['id']}');
              },
              child: const Icon(Icons.edit, color: Colors.green),
            ),
            SizedBox(width: 10),
            InkWell(
              onTap: () async {
                await serviceService.deleteService(
                  businessId: businessId,
                  serviceId: order['id'],
                );
              },
              child: Icon(Icons.delete, color: Colors.red),
            ),
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
