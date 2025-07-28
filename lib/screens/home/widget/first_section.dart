import 'package:creativolabs/api/service_service.dart';
import 'package:creativolabs/core/constants/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class FirstSection extends StatelessWidget {
  const FirstSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'LO NUEVO',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.purple.shade800,
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Center(
            child: Text(
              'Descubre lo nuevo y más destacado',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Center(
            child: Text(
              'Explora los últimos perfiles y negocios que se han unido a nuestra plataforma.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
          ),
          const SizedBox(height: 30),
          const InfluencerGrid(),
        ],
      ),
    );
  }
}

class InfluencerGrid extends StatelessWidget {
  const InfluencerGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final serviceService = ServiceService();

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: serviceService.getLast4GlobalServices(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          if (snapshot.hasError) {
            debugPrint('🔥 Error en getLast4GlobalServices: ${snapshot.error}');
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          // return const Center(child: Text('Error al cargar los servicios.'));
        }

        final data = snapshot.data;

        if (data == null || data.isEmpty) {
          return const Center(child: Text('No hay nuevos servicios.'));
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
                    'businessId': servicio['businessId'] ?? 'No tiene id',
                    'name': servicio['name'] ?? 'Sin nombre',
                    'price': servicio['price'] ?? 'Sin precio',
                    'description': servicio['description'] ?? '',
                    'category':
                        (servicio['category'] as List<dynamic>?)?.join(', ') ??
                            'GENERAL',
                    'usuario': servicio['owner'] ?? '@usuario',
                    'imagen':
                        servicio['imagen'] ?? 'https://via.placeholder.com/300',
                    'social': ['instagram', 'facebook'] // por ahora simulado
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

class InfluencerCard extends StatelessWidget {
  final Map<String, dynamic> info;

  const InfluencerCard({super.key, required this.info});

  IconData _getIcon(String key) {
    switch (key) {
      case 'instagram':
        return FontAwesomeIcons.instagram;
      case 'facebook':
        return FontAwesomeIcons.facebook;
      case 'twitter':
        return FontAwesomeIcons.twitter;
      case 'linkedin':
        return FontAwesomeIcons.linkedin;
      default:
        return Icons.link;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          context.go('/signup');
        } else {
          // ignore: use_build_context_synchronously
          context.push(
            '/create-order',
            extra: {
              'businessId': info['businessId'],
              'name': info['name'],
              'price': info['price'],
              // 'user': userData,
            },
          );
        }
      },
      child: Card(
        color: CustomColor.navBarBg,
        child: IntrinsicHeight(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: info['imagen'] != null &&
                              info['imagen'].toString().isNotEmpty
                          ? DecorationImage(
                              image: NetworkImage(info['imagen']),
                              fit: BoxFit.cover,
                              onError: (error, stackTrace) =>
                                  debugPrint('❌ Error cargando imagen: $error'),
                            )
                          : null,
                      color: info['imagen'] == null ||
                              info['imagen'].toString().isEmpty
                          ? Colors.grey.shade300
                          : null,
                    ),
                    child: info['imagen'] == null ||
                            info['imagen'].toString().isEmpty
                        ? const Center(
                            child: Icon(
                              Icons.image_not_supported,
                              size: 48,
                              color: Colors.grey,
                            ),
                          )
                        : null,
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.purple[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        info['category'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 150,
                    left: 2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      child: CircleAvatar(
                        backgroundColor: Colors.purple,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            info['name'],
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            info['price'],
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  info['usuario'],
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                child: Row(
                  children: List.generate(
                    info['social'].length,
                    (i) => Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: Icon(
                        _getIcon(info['social'][i]),
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
