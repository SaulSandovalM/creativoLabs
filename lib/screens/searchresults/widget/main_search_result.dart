import 'package:creativolabs/api/service_service.dart';
import 'package:creativolabs/core/widgets/back_buttons.dart';
import 'package:creativolabs/core/widgets/paginated_table.dart';
import 'package:creativolabs/screens/searchresults/widget/modal_search.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainSearchResult extends StatelessWidget {
  final String query;

  const MainSearchResult({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    final serviceService = ServiceService();

    void showOrderSideModal(BuildContext context, Map<String, dynamic> data) {
      showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: "Detalle del servicio",
        transitionDuration: Duration(milliseconds: 300),
        pageBuilder: (context, animation, secondaryAnimation) {
          return Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.4,
              height: MediaQuery.of(context).size.height,
              color: Colors.white,
              child: Material(
                child: ModalSearch(serviceData: data),
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BackButtons(
          title: 'Atras',
          onPressed: () => context.go('/customers'),
          icon: Icons.arrow_back,
        ),
        const SizedBox(height: 20),
        Text(
          'Resultados para "$query"',
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: PaginatedTable<Map<String, dynamic>>(
            stream: serviceService.searchAllServicesByCategory(query),
            columns: const [
              DataColumn(
                label: Text(
                  'Nombre',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'Precio',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'Categoria',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'Calificación',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  '',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
            buildRow: (service, index) {
              return DataRow(cells: [
                DataCell(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(service['name'] ?? 'Sin nombre'),
                      Text(
                        service['description'] ?? 'Sin descripción',
                        style: TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                DataCell(
                  Text(
                    service['price'] != null
                        ? '\$${service['price'].toString()}'
                        : 'Sin precio',
                  ),
                ),
                DataCell(
                  Text(
                    service['category'] is List
                        ? (service['category'] as List).join(', ')
                        : (service['category'] ?? ''),
                  ),
                ),
                DataCell(Row(
                  children: [
                    Icon(Icons.star_border),
                    Text('0.0 (0)'),
                  ],
                )),
                DataCell(
                  IconButton(
                    icon: const Icon(Icons.remove_red_eye),
                    tooltip: 'Ver detalles',
                    onPressed: () => showOrderSideModal(context, service),
                  ),
                ),
              ]);
            },
            // rowsPerPage: 5,
          ),
        ),
      ],
    );
  }
}
