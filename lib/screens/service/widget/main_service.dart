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
          DataColumn(
            label: Text(
              'Servicio',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Precio',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Descripción',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Categoría',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Acciones',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
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
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (value) {
                    if (value == 'edit') {
                      context.go('/edit-service/${data['id']}');
                    } else if (value == 'delete') {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Eliminar servicio'),
                          content: const Text(
                              '¿Está seguro de que desea eliminar este servicio?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.of(context).pop();
                                await ServiceService().deleteService(
                                  businessId: businessId,
                                  serviceId: data['id'],
                                );
                                // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Servicio eliminado'),
                                  ),
                                );
                              },
                              child: const Text('Eliminar',
                                  style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 18),
                          SizedBox(width: 8),
                          Text('Editar'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 18, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Eliminar'),
                        ],
                      ),
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
