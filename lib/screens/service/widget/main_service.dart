import 'package:creativolabs/api/service_service.dart';
import 'package:creativolabs/core/widgets/paginated_table.dart';
import 'package:creativolabs/providers/business_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

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
      child: PaginatedTable<Map<String, dynamic>>(
        stream: serviceService
            .getServiceStreamByBusiness(businessId)
            .map((snapshot) => snapshot.docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  data['id'] = doc.id;
                  return data;
                }).toList()),
        columns: const [
          DataColumn(label: Text('Servicio')),
          DataColumn(label: Text('Precio')),
          DataColumn(label: Text('Descripción')),
          DataColumn(label: Text('Categoría')),
          DataColumn(label: Text('')),
        ],
        buildRow: (data, index) {
          return DataRow(
            cells: [
              DataCell(
                Text(data['name'] ?? 'Sin nombre'),
              ),
              DataCell(
                Text(data['price'] != null
                    ? '\$${data['price'].toString()}'
                    : 'Sin precio'),
              ),
              DataCell(Text(data['description'] ?? 'Sin descripción')),
              DataCell(
                Text(
                  data['category'] != null && data['category'] is List
                      ? (data['category'] as List).join(', ')
                      : (data['category']?.toString() ?? 'Sin categoría'),
                ),
              ),
              DataCell(
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        context.go('/edit-service/${data['id']}');
                      },
                      child: const Icon(Icons.edit, color: Colors.green),
                    ),
                    SizedBox(width: 10),
                    InkWell(
                      onTap: () async {
                        await serviceService.deleteService(
                          businessId: businessId,
                          serviceId: data['id'],
                        );
                      },
                      child: Icon(Icons.delete, color: Colors.red),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
