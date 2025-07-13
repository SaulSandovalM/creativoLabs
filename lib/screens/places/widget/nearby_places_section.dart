import 'package:creativolabs/screens/home/widget/first_section.dart';
import 'package:flutter/material.dart';
import 'package:creativolabs/api/location_service.dart';
import 'package:creativolabs/api/service_service.dart';

class NearbyPlacesSection extends StatefulWidget {
  const NearbyPlacesSection({super.key});

  @override
  State<NearbyPlacesSection> createState() => _NearbyPlacesSectionState();
}

class _NearbyPlacesSectionState extends State<NearbyPlacesSection> {
  final locationService = LocationService();
  final serviceService = ServiceService();

  late Future<List<Map<String, dynamic>>> _futureNearbyServices;

  @override
  void initState() {
    super.initState();
    _futureNearbyServices = loadNearbyServices();
  }

  Future<List<Map<String, dynamic>>> loadNearbyServices() async {
    final position = await locationService.getCurrentLocation();
    return await serviceService.getNearbyServices(position);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _futureNearbyServices,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          debugPrint('🛑 Error de ubicación o servicios: ${snapshot.error}');
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final data = snapshot.data;

        if (data == null || data.isEmpty) {
          return const Center(child: Text('No hay servicios cerca.'));
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            int crossAxisCount = constraints.maxWidth > 1000
                ? 4
                : constraints.maxWidth > 600
                    ? 2
                    : 1;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: data.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.65,
                ),
                itemBuilder: (context, index) {
                  final servicio = data[index];
                  return InfluencerCard(info: {
                    'nombre': servicio['name'] ?? 'Sin nombre',
                    'descripcion': servicio['description'] ?? '',
                    'categoria':
                        (servicio['category'] as List<dynamic>?)?.join(', ') ??
                            'GENERAL',
                    'usuario': servicio['owner'] ?? '@usuario',
                    'imagen':
                        servicio['imagen'] ?? 'https://via.placeholder.com/300',
                    'social': ['facebook', 'instagram']
                  });
                },
              ),
            );
          },
        );
      },
    );
  }
}
