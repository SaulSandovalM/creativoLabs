import 'package:creativolabs/core/widgets/custom_card.dart';
import 'package:creativolabs/core/widgets/container.dart';
import 'package:creativolabs/screens/customers/widget/main_detail_customer.dart';
import 'package:creativolabs/services/customers_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DetailCustomer extends StatelessWidget {
  final String? id;
  const DetailCustomer({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    if (id == null) {
      return const Center(child: Text('ID no válido'));
    }

    final customerService = CustomersService();

    final List<Map<String, dynamic>> addresses = [
      {
        'fullAddress':
            '2da Privada del Marquez #104, Haciendas de hidalgo,\nPachuca de Soto, Hidalgo,\n42086',
        'isPrimary': true,
      },
      {
        'fullAddress':
            '4807 Lighthouse Drive,\nSpringfield, Missouri, United States,\n65804',
        'isPrimary': false,
      },
    ];

    return FutureBuilder<Map<String, dynamic>?>(
      future: customerService.getCustomerById(id!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('Cliente no encontrado'));
        }

        final customer = snapshot.data!;

        return MainContainer(
          child: Column(
            children: [
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      context.go('/customers');
                    },
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Clientes'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      elevation: 0,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              MainDetailCustomer(customer: customer),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        CustomCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Material(
                                        color: Colors.white,
                                        shape: const CircleBorder(),
                                        elevation: 4,
                                        child: Padding(
                                          padding: const EdgeInsets.all(6),
                                          child: Icon(
                                            Icons.person_outlined,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 20),
                                      Text(
                                        'Detalles basicos',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Icon(Icons.edit_outlined),
                                ],
                              ),
                              SizedBox(height: 20),
                              Text(
                                'Nombre',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF667085),
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                customer['name'],
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 10),
                              Divider(),
                              SizedBox(height: 10),
                              Text(
                                'Correo',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF667085),
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                customer['email'],
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 10),
                              Divider(),
                              SizedBox(height: 10),
                              Text(
                                'Teléfono',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF667085),
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                customer['phoneNumber'] != null
                                    ? customer['phoneNumber'].toString()
                                    : 'Sin telefono',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 10),
                              Divider(),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        CustomCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Material(
                                        color: Colors.white,
                                        shape: const CircleBorder(),
                                        elevation: 4,
                                        child: Padding(
                                          padding: const EdgeInsets.all(6),
                                          child: Icon(
                                            Icons.security,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 20),
                                      Text(
                                        'Seguridad',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () async {
                                          if (id != null) {
                                            await CustomersService()
                                                .deleteCustomerById(id!);
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(
                                              255, 255, 0, 0),
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 16),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          textStyle:
                                              const TextStyle(fontSize: 16),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Text('Eliminar cuenta'),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                        'Un cliente eliminado no se puede recuperar. Todos los datos se eliminarán permanentemente.',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF667085),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        CustomCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Material(
                                        color: Colors.white,
                                        shape: const CircleBorder(),
                                        elevation: 4,
                                        child: Padding(
                                          padding: const EdgeInsets.all(6),
                                          child: Icon(
                                            Icons.shopping_cart_outlined,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 20),
                                      Text(
                                        'Pagos',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      context.go('/customers');
                                    },
                                    icon: const Icon(Icons.add),
                                    label: const Text('Agregar pago'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.black,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                      elevation: 0,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey, // Color del borde
                                    width: 1, // Grosor del borde
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'PEDIDOS TOTALES',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Color(0xFF667085),
                                          ),
                                        ),
                                        Text(
                                          '5',
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'VALOR DE LOS PEDIDOS',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Color(0xFF667085),
                                          ),
                                        ),
                                        Text(
                                          '\$ 1,254',
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          'REEMBOLSOS',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Color(0xFF667085),
                                          ),
                                        ),
                                        Text(
                                          '\$ 1,254',
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                child: DataTable(
                                  columns: const [
                                    DataColumn(
                                      label: Text(
                                        'Id',
                                        style: TextStyle(
                                          color: Color(0xFF667085),
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'Precio',
                                        style: TextStyle(
                                          color: Color(0xFF667085),
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'Fecha',
                                        style: TextStyle(
                                          color: Color(0xFF667085),
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'Estatus',
                                        style: TextStyle(
                                          color: Color(0xFF667085),
                                        ),
                                      ),
                                    ),
                                  ],
                                  rows: [
                                    DataRow(
                                      cells: [
                                        DataCell(
                                          Text(
                                            '123456',
                                            style: TextStyle(
                                              color: Colors.blue,
                                            ),
                                          ),
                                        ),
                                        DataCell(Text('\$1,254')),
                                        DataCell(Text('21/05/2025')),
                                        DataCell(
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 6),
                                            decoration: BoxDecoration(
                                              color: Color(0xFFD1FADF),
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            child: const Text(
                                              'Pagado',
                                              style: TextStyle(
                                                color: Color(0xFF027A48),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        CustomCard(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Material(
                                        color: Colors.white,
                                        shape: const CircleBorder(),
                                        elevation: 4,
                                        child: Padding(
                                          padding: const EdgeInsets.all(6),
                                          child: Icon(
                                            Icons.home_outlined,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 20),
                                      Text(
                                        'Direcciones',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      context.go('/customers');
                                    },
                                    icon: const Icon(Icons.add),
                                    label: const Text('Agregar'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.black,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                      elevation: 0,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  final isWide = constraints.maxWidth >= 600;
                                  final itemWidth = isWide
                                      ? (constraints.maxWidth / 2) - 12
                                      : constraints.maxWidth;
                                  return Wrap(
                                    spacing: 16,
                                    runSpacing: 16,
                                    children: addresses.map((address) {
                                      return SizedBox(
                                        width: itemWidth,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey.shade300),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          padding: const EdgeInsets.all(16),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                address['fullAddress'],
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black87,
                                                  height: 1.4,
                                                ),
                                              ),
                                              const SizedBox(height: 12),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  if (address['isPrimary'])
                                                    Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 12,
                                                          vertical: 6),
                                                      decoration: BoxDecoration(
                                                        color: const Color(
                                                            0xFFFFF3C6),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(16),
                                                      ),
                                                      child: const Text(
                                                        'Primary',
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xFFC16A00),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    )
                                                  else
                                                    const SizedBox(width: 70),
                                                  TextButton.icon(
                                                    onPressed: () {
                                                      context
                                                          .go('/edit-address');
                                                    },
                                                    icon: const Icon(
                                                        Icons.edit_outlined,
                                                        size: 18),
                                                    label: const Text('Edit'),
                                                    style: TextButton.styleFrom(
                                                      foregroundColor:
                                                          Colors.black87,
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 8),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }
}
