import 'package:flutter/material.dart';

class Select<T> extends StatelessWidget {
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?)? onChanged;
  final String? Function(T?)? validator;
  final InputDecoration? decoration;

  const Select({
    super.key,
    required this.value,
    required this.items,
    this.onChanged,
    this.validator,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      onChanged: onChanged,
      validator: validator,
      decoration:
          decoration ?? const InputDecoration(border: OutlineInputBorder()),
    );
  }
}
