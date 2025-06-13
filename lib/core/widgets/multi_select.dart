import 'package:flutter/material.dart';

class MultiSelect extends StatelessWidget {
  final List<String> selectedCategories;
  final VoidCallback onTap;
  final String? labelText;

  const MultiSelect({
    super.key,
    required this.selectedCategories,
    required this.onTap,
    required this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AbsorbPointer(
        child: TextFormField(
          decoration: InputDecoration(
            labelText: labelText,
            border: const OutlineInputBorder(),
          ),
          controller: TextEditingController(
            text: selectedCategories.join(', '),
          ),
          validator: (value) {
            if (selectedCategories.isEmpty) {
              return 'Por favor selecciona al menos una categoría';
            }
            return null;
          },
        ),
      ),
    );
  }
}
