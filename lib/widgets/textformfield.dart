import 'package:flutter/material.dart';

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
