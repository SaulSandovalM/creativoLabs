import 'package:flutter/material.dart';

class MainContainer extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;

  const MainContainer({
    super.key,
    required this.child,
    this.backgroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 600),
          margin: const EdgeInsets.symmetric(horizontal: 40),
          child: child,
        ),
      ),
    );
  }
}
