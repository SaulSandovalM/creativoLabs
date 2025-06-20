import 'package:flutter/material.dart';

class CustomOutlineButton extends StatelessWidget {
  const CustomOutlineButton({
    super.key,
    required this.width,
    required this.title,
  });

  final double width;
  final String title;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        width: width,
        height: MediaQuery.of(context).size.height * 0.05,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            width: 2.0,
            color: Colors.blue,
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 15.0,
              color: Colors.blue,
            ),
          ),
        ),
      ),
    );
  }
}
