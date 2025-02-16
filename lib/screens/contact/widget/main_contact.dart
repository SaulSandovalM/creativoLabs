import 'package:creativolabs/core/widgets/container.dart';
import 'package:flutter/material.dart';

class MainContact extends StatefulWidget {
  final double headerHeight;

  const MainContact({super.key, required this.headerHeight});

  @override
  MainContactState createState() => MainContactState();
}

class MainContactState extends State<MainContact> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double availableHeight = screenHeight - widget.headerHeight;

    return MainContainer(
      child: SizedBox(
        height: availableHeight,
        width: double.infinity,
        child: const Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Contactanos',
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'CreativeLabs hará que su servicio luzca moderno y profesional mientras le ahorra un tiempo precioso.',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Placeholder(),
            ),
          ],
        ),
      ),
    );
  }
}
