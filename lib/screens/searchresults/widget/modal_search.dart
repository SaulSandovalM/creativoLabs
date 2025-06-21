import 'package:creativolabs/core/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ModalSearch extends StatelessWidget {
  final Map<String, dynamic> serviceData;

  const ModalSearch({super.key, required this.serviceData});

  @override
  Widget build(BuildContext context) {
    debugPrint('ModalSearch: $serviceData');
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Detalle del servicio',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          ),
          const SizedBox(height: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 130,
                      child: Text(
                        'Nombre',
                        style: TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        serviceData['name'] ?? 'No disponible',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 130,
                      child: Text(
                        'Descripción',
                        style: TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        serviceData['description'] ?? 'No disponible',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 130,
                      child: Text(
                        'Precio',
                        style: TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        serviceData['price'] ?? 'No disponible',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Button(
            title: 'Solicitar Servicio',
            onPressed: () {
              context.pop();
              context.go(
                '/create-order',
                extra: {
                  'id': serviceData['businessId'],
                  'name': serviceData['name'],
                  'price': serviceData['price'],
                },
              );
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
