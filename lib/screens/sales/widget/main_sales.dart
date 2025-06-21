import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creativolabs/api/sales_service.dart';
import 'package:creativolabs/core/widgets/modal.dart';
import 'package:creativolabs/core/widgets/paginated_table.dart';
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

    void showOrderSideModal(BuildContext context, Map<String, dynamic> data) {
      showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: "Detalles Orden",
        transitionDuration: Duration(milliseconds: 300),
        pageBuilder: (context, animation, secondaryAnimation) {
          return Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.4,
              height: MediaQuery.of(context).size.height,
              color: Colors.white,
              child: Material(
                child: Modal(orderData: data),
              ),
            ),
          );
        },
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          final tween = Tween<Offset>(begin: Offset(1, 0), end: Offset.zero);
          return SlideTransition(
            position: tween.animate(animation),
            child: child,
          );
        },
      );
    }

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
          DataColumn(
            label: Text(
              'Fecha',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Orden',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Método de Pago',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Cliente',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Estado',
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
              DataCell(Text(data['date'])),
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
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (value) {
                    if (value == 'show') {
                      showOrderSideModal(context, data);
                    } else if (value == 'edit') {
                      context.go('/edit-order/${data['id']}');
                    } else if (value == 'updateStatus') {
                      String selectedStatus = data['status'] ?? 'Pendiente';
                      showDialog(
                        context: context,
                        builder: (context) {
                          return StatefulBuilder(
                            builder: (context, setState) => AlertDialog(
                              title: const Text('Actualizar estatus'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    'Seleccione el nuevo estatus de la orden:',
                                  ),
                                  const SizedBox(height: 16),
                                  DropdownButtonFormField<String>(
                                    value: selectedStatus,
                                    items: [
                                      'Pendiente',
                                      'Completado',
                                      'Cancelado'
                                    ]
                                        .map((status) =>
                                            DropdownMenuItem<String>(
                                              value: status,
                                              child: Text(status),
                                            ))
                                        .toList(),
                                    decoration: const InputDecoration(
                                      labelText: 'Estatus',
                                      border: OutlineInputBorder(),
                                    ),
                                    onChanged: (newValue) {
                                      if (newValue != null) {
                                        setState(
                                            () => selectedStatus = newValue);
                                      }
                                    },
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('Cancelar'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    Navigator.of(context).pop();
                                    await salesService.updateStatusSale(
                                      businessId: businessId,
                                      orderId: data['id'],
                                      data: {'status': selectedStatus},
                                    );
                                    // ignore: use_build_context_synchronously
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Estatus de la orden actualizado',
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Actualizar estatus',
                                    style: TextStyle(color: Colors.green),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'show',
                      child: Row(
                        children: [
                          Icon(Icons.remove_red_eye, size: 18),
                          SizedBox(width: 8),
                          Text('Ver'),
                        ],
                      ),
                    ),
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
                      value: 'updateStatus',
                      child: Row(
                        children: [
                          Icon(Icons.update, size: 18, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Actualizar estatus'),
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
