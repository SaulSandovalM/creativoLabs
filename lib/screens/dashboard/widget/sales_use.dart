import 'package:creativolabs/core/widgets/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class SalesUse extends StatelessWidget {
  const SalesUse({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Resumen',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        '+28%',
                        style: TextStyle(
                          fontSize: 40,
                          color: Colors.teal,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text.rich(
                        TextSpan(
                          text: 'Aumento en los servicios ',
                          children: [
                            TextSpan(
                              text: '6,521',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(text: ' nuevas ordenes realizadas'),
                          ],
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Text.rich(
                    TextSpan(
                      text: 'Este año ',
                      style: TextStyle(color: Colors.blue),
                      children: [
                        TextSpan(
                          text:
                              'se prevé un aumento en su tráfico para finales del mes actual.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            SizedBox(
              height: 250,
              width: 400,
              child: BarChart(
                BarChartData(
                  barGroups: _buildBarGroups(),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, _) {
                          const months = [
                            'Jan',
                            'Feb',
                            'Mar',
                            'Apr',
                            'May',
                            'Jun',
                            'Jul',
                            'Aug',
                            'Sep',
                            'Oct',
                            'Nov',
                            'Dec'
                          ];
                          return Text(
                            months[value.toInt()],
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                        reservedSize: 30,
                      ),
                    ),
                    leftTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  barTouchData: BarTouchData(enabled: false),
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    final thisYear = [
      50.0,
      80.0,
      60.0,
      70.0,
      45.0,
      90.0,
      70.0,
      65.0,
      60.0,
      75.0,
      85.0,
      40.0
    ];
    final lastYear = [
      40.0,
      60.0,
      45.0,
      55.0,
      35.0,
      70.0,
      55.0,
      50.0,
      48.0,
      60.0,
      70.0,
      30.0
    ];

    return List.generate(12, (index) {
      return BarChartGroupData(
        x: index,
        barsSpace: 4,
        barRods: [
          BarChartRodData(
            toY: thisYear[index],
            width: 7,
            color: const Color(0xFF7065F0),
            borderRadius: BorderRadius.circular(4),
          ),
          BarChartRodData(
            toY: lastYear[index],
            width: 7,
            color: const Color(0xFFB3AAFD),
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    });
  }
}
