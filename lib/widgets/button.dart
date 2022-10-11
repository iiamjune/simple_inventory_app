import 'package:flutter/material.dart';

class MainButton extends StatefulWidget {
  const MainButton(
      {super.key, required this.onPressed, required this.buttonLabel});
  final VoidCallback? onPressed;
  final String buttonLabel;

  @override
  State<MainButton> createState() => _MainButtonState();
}

class _MainButtonState extends State<MainButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.indigo[600]),
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))),
      ),
      onPressed: widget.onPressed,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          widget.buttonLabel,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
