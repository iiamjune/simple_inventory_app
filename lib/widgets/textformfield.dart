import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StandardTextField extends StatefulWidget {
  const StandardTextField({
    super.key,
    required this.label,
    this.controller,
    this.errorText,
  });
  final String? label;
  final TextEditingController? controller;
  final String? errorText;

  @override
  State<StandardTextField> createState() => _StandardTextFieldState();
}

class _StandardTextFieldState extends State<StandardTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: widget.label,
          errorText: widget.errorText),
    );
  }
}

class PasswordTextField extends StatefulWidget {
  const PasswordTextField({
    super.key,
    required this.label,
    this.controller,
    this.errorText,
  });
  final String? label;
  final TextEditingController? controller;
  final String? errorText;

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: true,
      controller: widget.controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: widget.label,
        errorText: widget.errorText,
      ),
    );
  }
}

class ProductField extends StatefulWidget {
  const ProductField({
    super.key,
    required this.controller,
    required this.label,
    this.enabled = true,
    this.keyboardType,
  });
  final TextEditingController controller;
  final String label;
  final bool enabled;
  final TextInputType? keyboardType;

  @override
  State<ProductField> createState() => _ProductFieldState();
}

class _ProductFieldState extends State<ProductField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: widget.enabled,
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
          border: const OutlineInputBorder(), labelText: widget.label),
    );
  }
}

class ProductIdField extends StatefulWidget {
  const ProductIdField({
    super.key,
    required this.flex,
    required this.controller,
    required this.label,
  });
  final TextEditingController controller;
  final int flex;
  final String label;

  @override
  State<ProductIdField> createState() => _ProductIdFieldState();
}

class _ProductIdFieldState extends State<ProductIdField> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: widget.flex,
        child: TextFormField(
          enabled: false,
          controller: widget.controller,
          decoration: InputDecoration(
              border: const OutlineInputBorder(), labelText: widget.label),
        ));
  }
}
