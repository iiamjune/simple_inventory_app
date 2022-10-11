import 'package:flutter/material.dart';

class ProductDropdown extends StatefulWidget {
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
  State<ProductDropdown> createState() => _ProductDropdownState();
}

class _ProductDropdownState extends State<ProductDropdown> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: DropdownButtonFormField<bool>(
            value: widget.value,
            decoration: InputDecoration(
                border: const OutlineInputBorder(), labelText: widget.label),
            items: widget.items,
            onChanged: widget.onChanged,
          ),
        )
      ],
    );
  }
}
