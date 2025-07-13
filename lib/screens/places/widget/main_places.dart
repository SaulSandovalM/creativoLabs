import 'package:flutter/material.dart';
import 'package:creativolabs/api/service_service.dart';

class MainPlaces extends StatelessWidget {
  const MainPlaces({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;
    final servicesService = ServiceService();

    return Row(
      children: [
        Expanded(
          flex: isDesktop ? 3 : 5,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: servicesService.searchAllServices(),
              builder: (context, snapshot) {
                debugPrint('Snapshot: ${snapshot.connectionState}');
                debugPrint('Has data: ${snapshot.hasData}');
                debugPrint('Error: ${snapshot.error}');

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No se encontraron alojamientos.'),
                  );
                }

                final alojamientos = snapshot.data!;

                return ListView.builder(
                  itemCount: alojamientos.length,
                  itemBuilder: (context, index) {
                    final data = alojamientos[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (data['imagen'] != null &&
                                data['imagen'].toString().isNotEmpty)
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(12)),
                                child: Image.network(
                                  data['imagen'],
                                  height: 180,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.broken_image),
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data['name'] ?? 'Sin título',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(data['description'] ?? ''),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${data['price'] ?? 0} MXN',
                                    style:
                                        const TextStyle(color: Colors.black54),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
        if (isDesktop)
          Expanded(
            flex: 4,
            child: Container(
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Text(
                  'Aquí va el mapa (Google Maps)',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
