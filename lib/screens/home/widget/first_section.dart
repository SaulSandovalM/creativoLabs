import 'package:creativolabs/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
      // ),
    );
  }
}

class InfluencerGrid extends StatelessWidget {
  const InfluencerGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final data = influencerData;

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
              // mainAxisExtent: 350,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.65,
            ),
            itemBuilder: (context, index) {
              return InfluencerCard(info: data[index]);
            },
          ),
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
    return Card(
      color: CustomColor.navBarBg,
      child: IntrinsicHeight(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.network(
                  info['imagen'],
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
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
                      info['categoria'],
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
                          info['nombre'],
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          info['descripcion'],
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
    );
  }
}

// Datos de prueba
final List<Map<String, dynamic>> influencerData = List.generate(
    4,
    (_) => {
          'nombre': 'Brenda Cifuentes',
          'descripcion': 'Crítica cultural y bloguera que radica en Puebla.',
          'categoria': 'COMIDA',
          'usuario': '@sitioincreible',
          'imagen':
              'https://images.unsplash.com/photo-1600891964599-f61ba0e24092',
          'avatar': Icons.person,
          'social': ['instagram', 'facebook', 'twitter', 'linkedin']
        });
