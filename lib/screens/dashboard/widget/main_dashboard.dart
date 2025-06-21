import 'package:creativolabs/api/sales_service.dart';
import 'package:creativolabs/core/widgets/dashboard_card.dart';
import 'package:creativolabs/providers/business_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainDashboard extends StatefulWidget {
  const MainDashboard({super.key});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  final SalesService _salesService = SalesService();

  int completeOrdersCount = 0;
  int pendingOrdersCount = 0;
  int customersCount = 0;

  String? businessId;

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
    return Row(
      children: [
        DashboardCard(
          icon: Icons.list,
          title: 'Órdenes Completadas',
          value: completeOrdersCount,
          previousValue: 1,
        ),
        const SizedBox(width: 20),
        DashboardCard(
          icon: Icons.group_outlined,
          title: 'Clientes',
          value: customersCount,
          previousValue: 15,
        ),
        const SizedBox(width: 20),
        DashboardCard(
          icon: Icons.warning_amber,
          title: 'Órdenes Pendientes',
          value: pendingOrdersCount,
          previousValue: 15,
        ),
      ],
    );
  }
}
