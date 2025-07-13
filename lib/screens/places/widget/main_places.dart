import 'package:creativolabs/api/location_service.dart';
import 'package:flutter/material.dart';
import 'package:creativolabs/api/service_service.dart';

class MainPlaces extends StatefulWidget {
  const MainPlaces({super.key});

  @override
  State<MainPlaces> createState() => _MainPlacesState();
}

class _MainPlacesState extends State<MainPlaces> {
  final locationService = LocationService();
  final serviceService = ServiceService();

  late Future<List<Map<String, dynamic>>> _futureServices;

  @override
  void initState() {
    super.initState();
    _futureServices = loadNearbyServices();
  }

  Future<List<Map<String, dynamic>>> loadNearbyServices() async {
    final position = await locationService.getCurrentLocation();
    return await serviceService.getNearbyServices(position);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _futureServices,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final services = snapshot.data ?? [];

        if (services.isEmpty) {
          return const Center(child: Text('No hay servicios cerca.'));
        }

        return SizedBox(
          height: 400,
          child: ListView.builder(
            itemCount: services.length,
            itemBuilder: (context, index) {
              final service = services[index];
              return ListTile(
                title: Text(service['name']),
                subtitle: Text(service['description']),
              );
            },
          ),
        );
      },
    );
  }
}
