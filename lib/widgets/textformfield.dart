import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthTextField extends StatefulWidget {
  const AuthTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.errorText,
    this.obscureText = false,
  });
  final String? label;
  final TextEditingController? controller;
  final String? errorText;
  final bool obscureText;

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: widget.obscureText,
      controller: widget.controller,
      decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: widget.label,
          errorText: widget.errorText),
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
