import 'package:flutter/material.dart';

class Modal extends StatelessWidget {
  final Map<String, dynamic> orderData;

  const Modal({super.key, required this.orderData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 24),
          _buildDetails(),
          const SizedBox(height: 24),
          _buildLineItems(),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            orderData['orderNumber']?.toString() ??
                'Numero de orden no disponible',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        )
      ],
    );
  }

  Widget _buildDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Detalles',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 8),
        _buildDetailRow('Cliente', orderData['customerName'] ?? 'N/A'),
        _buildDetailRow(
            'Dirección',
            orderData['address'] +
                    ',\n' +
                    orderData['city'] +
                    ',\n' +
                    orderData['state'] +
                    ',\n' +
                    orderData['cp'] ??
                'N/A'),
        _buildDetailRow('Fecha', orderData['date'] ?? 'N/A'),
        _buildDetailRow('Estado', orderData['status'] ?? 'N/A'),
        _buildDetailRow('Método de Pago', orderData['paymentMethod'] ?? 'N/A'),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: label == 'Cliente' ? Colors.blue : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLineItems() {
    final service = orderData['service'] ?? 'Servicio no especificado';
    final price = orderData['price']?.toDouble() ?? 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Servicio',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Tipo de Servicio')),
              DataColumn(label: Text('Precio')),
            ],
            rows: [
              DataRow(cells: [
                DataCell(Text(service.toString())),
                DataCell(Text('\$${price.toStringAsFixed(2)}')),
              ]),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              '\$${price.toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        )
      ],
    );
  }
}
