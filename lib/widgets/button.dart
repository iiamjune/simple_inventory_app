import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  const MainButton(
      {super.key,
      required this.buttonLabel,
      this.isProcessing = false,
      this.process});
  final String buttonLabel;
  final bool isProcessing;
  final Function()? process;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.indigo[600],
        backgroundColor: Colors.indigo[600],
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        disabledBackgroundColor: Colors.indigo[600]?.withOpacity(0.30),
      ),
      onPressed: isProcessing ? null : process,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          buttonLabel,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
