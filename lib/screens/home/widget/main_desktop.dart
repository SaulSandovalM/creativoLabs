import 'package:flutter/material.dart';

import '../../../core/constants/colors.dart';

class MainDesktop extends StatelessWidget {
  const MainDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: CustomColor.navBorder,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              'assets/images/profile.jpg',
              width: screenSize.width * 0.3,
              height: screenSize.width * 0.3 * 1.2,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 30),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SAUL SANDOVAL MONDRAGON',
                style: TextStyle(
                  fontSize: 30,
                  height: 1.5,
                  fontWeight: FontWeight.bold,
                  color: CustomColor.whitePrimary,
                ),
              ),
              Text(
                'Software Developer',
                style: TextStyle(
                  fontSize: 26,
                  color: CustomColor.whitePrimary,
                ),
              ),
              Text(
                'Arquitecto de código y visionario digital, soy Saúl Sandoval, un desarrollador de software apasionado por trazar puentes entre el presente y el futuro. Mi misión es transformar ideas en realidades digitales a través de soluciones innovadoras y funcionales, siempre guiado por una filosofía que combina arte, precisión y tecnología. En un mundo donde el neón ilumina la oscuridad y los datos son la nueva energía, me especializo en diseñar aplicaciones robustas que no solo operan, sino que inspiran. Con un enfoque en la experiencia del usuario y un compromiso inquebrantable con la excelencia, busco redefinir cómo interactuamos con el ecosistema digital. Bienvenido a mi universo, donde la creatividad y la tecnología convergen para construir el mañana.',
                style: TextStyle(
                  color: CustomColor.textDesc,
                  fontSize: 16,
                ),
              ),
              // const SizedBox(height: 15),
              // SizedBox(
              //   width: 250,
              //   child: ElevatedButton(
              //     onPressed: () {},
              //     child: const Text('Get in touch'),
              //   ),
              // ),
              // const SizedBox(height: 15),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: [
              //     for (int i = 0; i < languagesItems.length; i++)
              //       Image.network(
              //         languagesItems[i]['img']!,
              //         width: 30,
              //         height: 30,
              //         fit: BoxFit.cover,
              //       ),
              //   ],
              // )
            ],
          ),
        ),
      ],
    );
  }
}
