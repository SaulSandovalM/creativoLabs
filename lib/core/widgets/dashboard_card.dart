import 'package:creativolabs/core/widgets/custom_card.dart';
import 'package:flutter/material.dart';

class DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final int value;
  final int previousValue;

  const DashboardCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.previousValue,
  });

  @override
  Widget build(BuildContext context) {
    final difference = value - previousValue;
    final isIncrement = difference > 0;
    final isDecrement = difference < 0;

    IconData trendIcon;
    Color trendColor;

    if (isIncrement) {
      trendIcon = Icons.trending_up;
      trendColor = Colors.green;
    } else if (isDecrement) {
      trendIcon = Icons.trending_down;
      trendColor = Colors.red;
    } else {
      trendIcon = Icons.horizontal_rule;
      trendColor = Colors.grey;
    }

    return Expanded(
      flex: 1,
      child: CustomCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                    child: Icon(icon, size: 30, color: Colors.black),
                  ),
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    Text(
                      '$value',
                      style: const TextStyle(
                        fontSize: 35,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 30, thickness: 1),
            Row(
              children: [
                Icon(trendIcon, color: trendColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  isIncrement
                      ? 'Incremento de $difference este mes'
                      : isDecrement
                          ? 'Decremento de ${difference.abs()} este mes'
                          : 'Sin cambios este mes',
                  style: TextStyle(
                    fontSize: 14,
                    color: trendColor,
                    fontWeight: FontWeight.w500,
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
