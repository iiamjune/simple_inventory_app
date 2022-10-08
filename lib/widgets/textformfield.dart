import 'package:flutter/material.dart';

class StandardTextField extends StatefulWidget {
  const StandardTextField(
      {super.key,
      required this.label,
      required this.validator,
      required this.onSaved});
  final String? label;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;

  @override
  State<StandardTextField> createState() => _StandardTextFieldState();
}

class _StandardTextFieldState extends State<StandardTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: widget.validator,
      onSaved: widget.onSaved,
      decoration: InputDecoration(
          border: const OutlineInputBorder(), labelText: widget.label),
    );
  }
}

class PasswordTextField extends StatefulWidget {
  const PasswordTextField({
    super.key,
    required this.label,
    this.controller,
    required this.onSaved,
    required this.validator,
  });
  final String? label;
  final TextEditingController? controller;
  final void Function(String?)? onSaved;
  final String? Function(String?)? validator;

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: true,
      controller: widget.controller,
      onSaved: widget.onSaved,
      validator: widget.validator,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: widget.label,
      ),
    );
  }
}
