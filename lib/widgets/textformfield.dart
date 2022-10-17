import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      controller: controller,
      decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: label,
          errorText: errorText),
    );
  }
}

class ProductField extends StatelessWidget {
  const ProductField({
    super.key,
    required this.label,
    required this.controller,
    this.errorText,
    this.enabled = true,
    this.keyboardType,
  });
  final String label;
  final TextEditingController controller;
  final String? errorText;
  final bool enabled;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled,
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: label,
          errorText: errorText),
    );
  }
}

class ProductIdField extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Expanded(
        flex: flex,
        child: TextFormField(
          enabled: false,
          controller: controller,
          decoration: InputDecoration(
              border: const OutlineInputBorder(), labelText: label),
        ));
  }
}
