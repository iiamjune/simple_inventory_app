import 'package:flutter/material.dart';

class ProductDropdown extends StatelessWidget {
  const ProductDropdown({
    super.key,
    required this.value,
    required this.label,
    required this.items,
    required this.onChanged,
  });
  final bool value;
  final String label;
  final List<DropdownMenuItem<bool>> items;
  final void Function(bool? item)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: DropdownButtonFormField<bool>(
            value: value,
            decoration: InputDecoration(
                border: const OutlineInputBorder(), labelText: label),
            items: items,
            onChanged: onChanged,
          ),
        )
      ],
    );
  }
}
