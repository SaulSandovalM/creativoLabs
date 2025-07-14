import 'package:creativolabs/screens/home/widget/first_section.dart';
import 'package:flutter/material.dart';
import 'package:creativolabs/api/service_service.dart';

class ServicesCategories extends StatefulWidget {
  const ServicesCategories({super.key});

  @override
  State<ServicesCategories> createState() => _ServicesCategoriesState();
}

class _ServicesCategoriesState extends State<ServicesCategories> {
  final serviceService = ServiceService();
  late Future<Map<String, List<Map<String, dynamic>>>> _futureGrouped;

  @override
  void initState() {
    super.initState();
    _futureGrouped = serviceService.getGroupedServicesByCategory();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, List<Map<String, dynamic>>>>(
      future: _futureGrouped,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final grouped = snapshot.data!;
        if (grouped.isEmpty) {
          return const Center(child: Text('No hay servicios disponibles.'));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: grouped.entries.map((entry) {
            final categoria = entry.key;
            final servicios = entry.value;

            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    categoria.toUpperCase(),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple.shade800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      int crossAxisCount = constraints.maxWidth > 1000
                          ? 4
                          : constraints.maxWidth > 600
                              ? 2
                              : 1;

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: servicios.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.65,
                        ),
                        itemBuilder: (context, index) {
                          final s = servicios[index];
                          return InfluencerCard(info: {
                            'nombre': s['name'] ?? 'Sin nombre',
                            'descripcion': s['description'] ?? '',
                            'categoria':
                                (s['category'] as List<dynamic>?)?.join(', ') ??
                                    'GENERAL',
                            'usuario': s['owner'] ?? '@usuario',
                            'imagen': s['imagen'] ??
                                'https://via.placeholder.com/300',
                            'social': ['facebook', 'instagram'],
                          });
                        },
                      );
                    },
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
