import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final ShapeBorder? shape;

  const CustomCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20.0),
    this.shape,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: shape ??
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
