import 'package:flutter/material.dart';

class TitleCard extends StatelessWidget {
  final String title;

  const TitleCard({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        // fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }
}
