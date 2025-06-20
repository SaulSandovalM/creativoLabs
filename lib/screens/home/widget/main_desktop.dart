import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

class MainDesktop extends StatefulWidget {
  final double headerHeight;

  const MainDesktop({super.key, required this.headerHeight});

  @override
  MainDesktopState createState() => MainDesktopState();
}

class MainDesktopState extends State<MainDesktop> {
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, dynamic>> categories = [
    {'icon': Icons.handyman, 'label': 'Carpinteros'},
    {'icon': Icons.plumbing, 'label': 'Plomeros'},
    {'icon': Icons.electrical_services, 'label': 'Electricistas'},
    {'icon': Icons.cleaning_services, 'label': 'Limpieza'},
    {'icon': Icons.car_repair, 'label': 'Mecánicos'},
    {'icon': Icons.home_repair_service, 'label': 'Reparaciones'},
    {'icon': Icons.pest_control, 'label': 'Plagas'},
    {'icon': Icons.landscape, 'label': 'Jardinería'},
  ];

  void _scrollLeft() {
    _scrollController.animateTo(
      _scrollController.offset - 150,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _scrollRight() {
    _scrollController.animateTo(
      _scrollController.offset + 150,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double availableHeight = screenHeight - widget.headerHeight;

    return SizedBox(
      height: availableHeight,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Center(
              child: Text(
                'TU DIRECTORIO DE SERVICIOS Y NEGOCIOS',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const Center(
              child: Text(
                '¿Qué servicio necesitas hoy?',
                style: TextStyle(
                  fontSize: 60,
                  color: Colors.black,
                ),
              ),
            ),
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                width: 600,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: '¿Qué servicio necesitas hoy?',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(
                        color: CustomColor.borderSearchColor,
                      ),
                    ),
                    filled: true,
                    fillColor: CustomColor.navBarBg,
                    contentPadding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
            ),
            const Center(
              child: Text(
                'Descubre expertos, impulsa tu ciudad',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 40),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        onPressed: _scrollLeft,
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 80,
                        child: ListView.builder(
                          controller: _scrollController,
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    categories[index]['icon'],
                                    size: 32,
                                    color: Colors.black54,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    categories[index]['label'],
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Center(
                      child: IconButton(
                        icon: const Icon(Icons.arrow_forward_ios),
                        onPressed: _scrollRight,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
