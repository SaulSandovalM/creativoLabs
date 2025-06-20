import 'package:creativolabs/api/sales_service.dart';
import 'package:creativolabs/core/widgets/container.dart';
import 'package:creativolabs/core/widgets/custom_card.dart';
import 'package:creativolabs/providers/business_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int completeOrdersCount = 0;
  int pendingOrdersCount = 0;
  int customersCount = 0;
  String? businessId;

  final SalesService _salesService = SalesService();

  @override
  void initState() {
    super.initState();
    businessId = Provider.of<BusinessModel>(context, listen: false).businessId;
    _loadCompleteOrdersData();
    _loadPendingOrdersData();
    _loadCustomersData();
  }

  Future<void> _loadCompleteOrdersData() async {
    final orders =
        await _salesService.getOrdersCount(businessId!, 'Completado');
    setState(() {
      completeOrdersCount = orders;
    });
  }

  Future<void> _loadPendingOrdersData() async {
    final orders = await _salesService.getOrdersCount(businessId!, 'Pendiente');
    setState(() {
      pendingOrdersCount = orders;
    });
  }

  Future<void> _loadCustomersData() async {
    final customers =
        await _salesService.getCustomersCountByBusiness(businessId!);
    setState(() {
      customersCount = customers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainContainer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Resumen',
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: CustomCard(
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Icon(
                              Icons.list,
                              size: 30,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ordenes Completadas',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              '$completeOrdersCount',
                              style: TextStyle(
                                fontSize: 35,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: CustomCard(
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Icon(
                              Icons.group_outlined,
                              size: 30,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Clientes',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              '$customersCount',
                              style: TextStyle(
                                fontSize: 35,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: CustomCard(
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Icon(
                              Icons.warning_amber,
                              size: 30,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ordenes Pendientes',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              '$pendingOrdersCount',
                              style: TextStyle(
                                fontSize: 35,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
