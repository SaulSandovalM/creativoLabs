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
    return Container(
      margin: const EdgeInsets.fromLTRB(40, 0, 40, 0),
      child: child,
    );
  }
}
