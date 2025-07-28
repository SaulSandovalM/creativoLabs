import 'package:flutter/material.dart';

class DetailContainer extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;

  const DetailContainer({
    super.key,
    required this.child,
    this.backgroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final containerWidth = screenWidth * 0.8;

    return SingleChildScrollView(
      child: SafeArea(
        child: Container(
          width: containerWidth > 900 ? 900 : containerWidth,
          constraints: const BoxConstraints(minHeight: 600),
          margin: const EdgeInsets.symmetric(horizontal: 40),
          child: child,
        ),
      ),
    );
  }
}
