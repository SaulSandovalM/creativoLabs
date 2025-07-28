import 'package:flutter/material.dart';

class SecondSection extends StatelessWidget {
  const SecondSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    final List<Map<String, String>> beneficios = [
      {
        'titulo': 'Encuentra al experto que necesitas',
        'descripcion':
            'Desde carpinteros hasta herreros, aquí conectas con los mejores oficios de tu ciudad, sin complicaciones.'
      },
      {
        'titulo': 'Calidad, confianza y cercanía',
        'descripcion':
            'Todos nuestros profesionales han sido verificados para garantizarte un servicio seguro y de primera.'
      },
      {
        'titulo': 'Apoya el talento local',
        'descripcion':
            'Impulsa la economía de tu comunidad contratando servicios de calidad cerca de ti.'
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: isMobile
          ? Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CREATIVO LABS',
                      style: TextStyle(
                        color: Colors.purple[800],
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'DESCUBRE LO MEJOR\nY A LOS MEJORES',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Negocios en un solo lugar...',
                      style: TextStyle(fontSize: 18, color: Colors.black87),
                    ),
                    const SizedBox(height: 30),
                    ...List.generate(
                      3,
                      (i) => const Padding(
                        padding: EdgeInsets.only(bottom: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              color: Colors.purple,
                              size: 28,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'TU IDEA PRINCIPAL VA AQUÍ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Solo hay espacio suficiente aquí para varias líneas de texto.\nAsegúrate de transmitir tu mensaje de manera clara y concisa.',
                                    style: TextStyle(color: Colors.black54),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final width = constraints.maxWidth;

                      return SizedBox(
                        height: 420,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                              top: 0,
                              left: width * 0.03,
                              child: Image.network(
                                'https://images.pexels.com/photos/32910565/pexels-photo-32910565.jpeg',
                                width: width * 0.4,
                                // height: width * 0.305,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 0,
                              left: width * 0.47,
                              child: Image.network(
                                'https://images.pexels.com/photos/12158043/pexels-photo-12158043.jpeg',
                                width: width * 0.4,
                                height: 420,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: width * 0.03,
                              child: Image.network(
                                'https://images.pexels.com/photos/1094767/pexels-photo-1094767.jpeg',
                                width: width * 0.4,
                                // height: width * 0.305,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CREATIVO LABS',
                        style: TextStyle(
                          color: Colors.purple[800],
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'DESCUBRE LO MEJOR\nY A LOS MEJORES',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Profesionales confiables, a solo un clic...',
                        style: TextStyle(fontSize: 18, color: Colors.black87),
                      ),
                      const SizedBox(height: 30),
                      Column(
                        children: List.generate(
                          beneficios.length,
                          (i) => Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.check_circle_outline,
                                  color: Colors.purple,
                                  size: 28,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        beneficios[i]['titulo']!,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                      Text(
                                        beneficios[i]['descripcion']!,
                                        style: const TextStyle(
                                          color: Colors.black54,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
