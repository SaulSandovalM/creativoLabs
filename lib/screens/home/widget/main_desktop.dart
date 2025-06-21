import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/colors.dart';

class MainDesktop extends StatefulWidget {
  final double headerHeight;

  const MainDesktop({super.key, required this.headerHeight});

  @override
  MainDesktopState createState() => MainDesktopState();
}

class MainDesktopState extends State<MainDesktop> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> categories = [
    {'icon': Icons.carpenter, 'label': 'Carpinteros'},
    {'icon': Icons.plumbing, 'label': 'Plomeros'},
    {'icon': Icons.electrical_services, 'label': 'Electricistas'},
    {'icon': Icons.cleaning_services, 'label': 'Limpieza'},
    {'icon': Icons.car_repair, 'label': 'Mecánicos'},
    {'icon': Icons.home_repair_service, 'label': 'Reparaciones'},
    {'icon': Icons.pest_control, 'label': 'Plagas'},
    {'icon': Icons.landscape, 'label': 'Jardinería'},
    {'icon': Icons.format_paint, 'label': 'Pintura'},
    {'icon': Icons.construction, 'label': 'Albañileria'},
    {'icon': Icons.key, 'label': 'Cerrajería'},
    {'icon': Icons.computer, 'label': 'Tecnología'},
    {'icon': Icons.pets, 'label': 'Mascotas'},
    {'icon': Icons.diversity_1, 'label': 'Cuidados'},
    {'icon': Icons.miscellaneous_services, 'label': 'Otros'},
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

  void _navigateToSearch(String query) {
    if (query.isNotEmpty) {
      debugPrint('Navegando a: /search/${Uri.encodeComponent(query)}');
      context.go('/search/${Uri.encodeComponent(query)}');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double availableHeight = screenHeight - widget.headerHeight;

    return SizedBox(
      height: availableHeight,
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'TU DIRECTORIO DE SERVICIOS Y NEGOCIOS',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const Text(
                '¿Qué servicio necesitas hoy?',
                style: TextStyle(
                  fontSize: 60,
                  color: Colors.black,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                width: 600,
                child: TextField(
                  controller: _searchController,
                  onSubmitted: _navigateToSearch,
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
              const Text(
                'Descubre expertos, impulsa tu ciudad',
                style: TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 40),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: _scrollLeft,
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 80,
                        child: ListView.builder(
                          controller: _scrollController,
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            final label = categories[index]['label'];
                            return GestureDetector(
                              onTap: () => _navigateToSearch(label),
                              child: Padding(
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
                                      label,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios),
                      onPressed: _scrollRight,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
