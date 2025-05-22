import 'package:flutter/material.dart';

class MainDetailCustomer extends StatefulWidget {
  final Map<String, dynamic> customer;
  const MainDetailCustomer({super.key, required this.customer});

  @override
  MainDetailCustomerState createState() => MainDetailCustomerState();
}

class MainDetailCustomerState extends State<MainDetailCustomer> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 35,
              backgroundImage: NetworkImage(
                'https://via.placeholder.com/150',
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      widget.customer['name'] ?? 'Sin nombre',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Chip(
                      label: const Text('Activo'),
                      backgroundColor: Colors.green.shade50,
                      avatar: const Icon(
                        Icons.check_circle,
                        color: Colors.teal,
                        size: 18,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      labelStyle: const TextStyle(
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  widget.customer['email'] ?? 'Sin nombre',
                  style: const TextStyle(
                    color: Color(0xFF667085),
                  ),
                ),
              ],
            ),
          ],
        ),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6A5BFF),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(fontSize: 16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Acciones'),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
      ],
    );
  }
}
