import 'package:flutter/material.dart';

class Answer extends StatefulWidget {
  const Answer({super.key});

  @override
  AnswerState createState() => AnswerState();
}

class AnswerState extends State<Answer> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      width: 1000,
      child: Column(
        children: [
          const Text(
            'No encuentras la respuesta que necesitas?',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Nuestro equipo de soporte está disponible de lunes a viernes, de 9:00 a.m. a 6:00 p.m. (hora local). También puedes encontrarnos en nuestras redes sociales para más actualizaciones y atención personalizada.',
            style: TextStyle(
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Nombre',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingresa tu nombre';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Correo electrónico',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingresa tu correo';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Mensaje',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingresa tu correo';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 15,
                            ),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Procesando datos...'),
                                ),
                              );
                            }
                          },
                          child: const Text("Enviar"),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
