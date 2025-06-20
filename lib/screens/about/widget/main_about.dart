import 'package:flutter/material.dart';

class MainAbout extends StatefulWidget {
  const MainAbout({super.key});

  @override
  MainAboutState createState() => MainAboutState();
}

class MainAboutState extends State<MainAbout> {
  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Conectamos talento con oportunidades',
              style: TextStyle(
                fontSize: 60,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              'Encuentra profesionales confiables para cualquier tarea o servicio.',
              style: TextStyle(
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              width: 800,
              child: Text(
                'Facilitamos la conexión entre clientes y expertos en diferentes oficios, garantizando calidad, seguridad y confianza en cada servicio contratado.',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 40),
            SizedBox(
              width: 800,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        '10K+',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Profesionales registrados.',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        '50K+',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Servicios completados con éxito.',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        '98%',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Clientes satisfechos.',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 40),
            Divider(
              color: Colors.grey,
              thickness: 1,
              height: 40,
            ),
            SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Text(
                              'Encuentra el profesional ideal para cada tarea.',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Text(
                              'Desde plomería y carpintería hasta diseño y programación, nuestra plataforma conecta clientes con expertos en una amplia variedad de servicios. Nuestro compromiso es brindar confianza y facilidad en cada contratación.',
                              style: TextStyle(
                                fontSize: 16,
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
            SizedBox(height: 40),
            Divider(
              color: Colors.grey,
              thickness: 1,
              height: 40,
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
