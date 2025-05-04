import 'package:creativolabs/core/widgets/container.dart';
import 'package:creativolabs/core/widgets/title_cards.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return MainContainer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        color: Colors.white,
                        child: SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TitleCard(
                                  title: 'Ventas Totales',
                                ),
                                const Text(
                                  '\$ 1,254',
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text(
                                  '-5%',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Card(
                        color: Colors.white,
                        child: SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TitleCard(
                                  title: 'Pedidos recientes',
                                ),
                                const SizedBox(height: 10),
                                OrdersList(),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Card(
                        color: Colors.white,
                        child: SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TitleCard(
                                  title: 'Inventario bajo',
                                ),
                                const SizedBox(height: 10),
                                StockList(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        color: Colors.white,
                        child: SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TitleCard(
                                  title: 'Ingresos & gastos',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Card(
                              color: Colors.white,
                              child: SizedBox(
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TitleCard(
                                        title: 'Metodos de pago',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Card(
                              color: Colors.white,
                              child: SizedBox(
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TitleCard(
                                        title: 'Clientes mas frecuentes',
                                      ),
                                      TopCustomersList(),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Card(
                        color: Colors.white,
                        child: SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TitleCard(
                                  title: 'Actividad',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class OrdersList extends StatelessWidget {
  final List<Map<String, dynamic>> orders = [
    {
      'id': 1001,
      'customer': 'Marvin Reed',
      'amount': 642.00,
      'status': 'Pendiente',
    },
    {
      'id': 1002,
      'customer': 'Kristin Wilson',
      'amount': 395.00,
      'status': 'Completado',
    },
    {
      'id': 1003,
      'customer': 'Tanye Davidson',
      'amount': 146.00,
      'status': 'Completado',
    },
    {
      'id': 1004,
      'customer': 'Jenny Spencer',
      'amount': 97.00,
      'status': 'Completado',
    },
  ];

  OrdersList({super.key});

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Completado':
        return Colors.green.withOpacity(0.2);
      case 'Pendiente':
      default:
        return Colors.grey.shade300;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: orders.map((order) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Row(
            children: [
              SizedBox(width: 40, child: Text(order['id'].toString())),
              Expanded(child: Text(order['customer'])),
              SizedBox(
                width: 80,
                child: Text(
                  '\$${order['amount'].toStringAsFixed(2)}',
                  textAlign: TextAlign.right,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(order['status']),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  order['status'],
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class StockList extends StatelessWidget {
  final List<Map<String, dynamic>> orders = [
    {
      'product': 'Producto 1',
      'amount': 97.00,
    },
    {
      'product': 'Producto 2',
      'amount': 97.00,
    },
    {
      'product': 'Producto 3',
      'amount': 97.00,
    },
    {
      'product': 'Producto 4',
      'amount': 97.00,
    },
  ];

  StockList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: orders.map((order) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Row(
            children: [
              Expanded(child: Text(order['product'])),
              SizedBox(
                width: 80,
                child: Text(
                  '\$${order['amount']}',
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class TopCustomersList extends StatelessWidget {
  final List<Map<String, dynamic>> orders = [
    {
      'customer': 'Cliente 1',
      'visits': 23,
    },
    {
      'customer': 'Cliente 2',
      'visits': 12,
    },
    {
      'customer': 'Cliente 3',
      'visits': 5,
    },
    {
      'customer': 'Cliente 4',
      'visits': 1,
    },
  ];

  TopCustomersList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: orders.map((order) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Row(
            children: [
              Expanded(child: Text(order['customer'])),
              SizedBox(
                width: 80,
                child: Text(
                  '${order['visits']}',
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
