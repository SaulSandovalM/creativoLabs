import 'package:flutter/material.dart';

class MainPolitics extends StatelessWidget {
  const MainPolitics({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 40),
                  Text(
                    'Politicas de reembolso',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Ultima mofiicación: 6 de enero de 2025',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 40),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Flexible(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '1. Generalidades',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'En [Nombre de la empresa], nos esforzamos por brindar un servicio de calidad y satisfacción a nuestros clientes. Sin embargo, entendemos que pueden surgir situaciones en las que sea necesario solicitar un reembolso. A continuación, detallamos nuestras políticas de reembolso.',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 30),
                      Text(
                        '2. Condiciones para solicitar un reembolso',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Podrás solicitar un reembolso si se cumple al menos una de las siguientes condiciones: El servicio contratado no fue entregado dentro del tiempo acordado. El servicio prestado no cumple con las especificaciones establecidas en el contrato o en la descripción del servicio. Se detectaron errores técnicos o problemas operativos que impidieron el uso adecuado del servicio. Se realizó un cobro duplicado por error del sistema.',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 30),
                      Text(
                        '3. Procedimiento para solicitar un reembolso',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Para solicitar un reembolso, debes seguir estos pasos: Contactarnos a través de nuestro correo electrónico [Correo de soporte] o mediante nuestro formulario de contacto. Indicar el motivo de la solicitud de reembolso y proporcionar la información de la compra (fecha, número de pedido o contrato). Adjuntar cualquier evidencia relevante (capturas de pantalla, correos electrónicos, documentos, etc.). Nuestro equipo revisará tu solicitud en un plazo máximo de 7 días hábiles.',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 30),
                      Text(
                        '4. Exclusiones',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'No aplicarán reembolsos en los siguientes casos: El servicio ha sido completado y entregado según lo acordado. El cliente ha decidido no utilizar el servicio después de su contratación sin justificación válida. Solicitudes realizadas fuera del plazo de garantía especificado.',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 30),
                      Text(
                        '5. Tiempo y método de reembolso',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Si tu solicitud de reembolso es aprobada, el monto será devuelto en un plazo de 7 a 15 días hábiles, dependiendo del método de pago utilizado. Los reembolsos se procesarán de la misma forma en que se realizó el pago original.',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 30),
                      Text(
                        '6. Contacto',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Si tienes dudas sobre nuestra política de reembolsos, puedes comunicarte con nuestro equipo de soporte en creativolabs@gmail.com o llamarnos al 7714407842.',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 30),
                      Text(
                        '7. ¿Qué información recopilamos?',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 30),
                      Text(
                        '8. ¿Qué información recopilamos?',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'How can you contact us about this notice?',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'If you have any questions or concerns about the privacy policy please contact us.',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'hi@maccarianagency.com via Gola 4 Milan, Milano 20143 Italy',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
