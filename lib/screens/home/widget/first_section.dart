import 'package:flutter/material.dart';

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
        ],
      ),
    );
  }
}
