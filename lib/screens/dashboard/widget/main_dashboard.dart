import 'package:flutter/material.dart';

class MainDashboard extends StatefulWidget {
  final double headerHeight;

  const MainDashboard({super.key, required this.headerHeight});

  @override
  MainDashboardState createState() => MainDashboardState();
}

class MainDashboardState extends State<MainDashboard> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;
        int crossAxisCount = 3;

        if (width < 900) crossAxisCount = 2;
        if (width < 600) crossAxisCount = 1;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 3 / 2,
          ),
          itemCount: 3,
          itemBuilder: (context, index) => _buildCard(),
        );
      },
    );
  }
}

Widget _buildCard() {
  return SizedBox(
    child: Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.devices, size: 50, color: Colors.blue),
            const SizedBox(height: 10),
            const Text(
              'Card Responsiva',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              'Esta tarjeta se ajusta automáticamente a la pantalla.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    ),
  );
}
