import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creativolabs/api/sales_service.dart';
import 'package:creativolabs/core/widgets/custom_card.dart';
import 'package:creativolabs/providers/business_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class CardEvents extends StatelessWidget {
  const CardEvents({super.key});

  @override
  Widget build(BuildContext context) {
    final businessId = Provider.of<BusinessModel>(context).businessId;
    final salesService = SalesService();

    return CustomCard(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
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
                    Icons.calendar_month,
                    size: 30,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Proximas ordenes',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          StreamBuilder<List<Map<String, dynamic>>>(
            stream: salesService.getUpcomingEvents(businessId!),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const CircularProgressIndicator();
              final events = snapshot.data!;
              return Column(
                children: events.map((event) {
                  final date = (event['dateTimeStamp'] as Timestamp).toDate();
                  final day = DateFormat('dd').format(date);
                  final month =
                      DateFormat('MMM', 'es').format(date).toUpperCase();
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Column(
                            children: [
                              Text(
                                month,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                day,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                event['service'] ?? '',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${event['time']}',
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.calendar_today_outlined),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          ),
          const Divider(height: 30),
          GestureDetector(
            onTap: () {
              context.go('/sales');
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Text(
                  'Ver todas las ordenes',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 6),
                Icon(Icons.arrow_right_alt),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
