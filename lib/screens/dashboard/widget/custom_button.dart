import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.width,
    required this.title,
    this.isIconButton = false,
  });

  final double width;
  final String title;
  final bool isIconButton;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        width: width,
        height: MediaQuery.of(context).size.height * 0.05,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: Colors.blue,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 15.0,
                color: Colors.white,
              ),
            ),
            if (isIconButton) ...[
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.005,
              ),
              const Icon(
                Icons.add,
                size: 20.0,
                color: Colors.white,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
