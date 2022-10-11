import 'package:flutter/material.dart';

import '../constants/labels.dart';

class Success extends StatelessWidget {
  const Success({super.key, this.message = 'Success', this.onContinue});
  final String? message;
  final VoidCallback? onContinue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[600],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(
            children: <Widget>[
              const Align(
                alignment: Alignment.center,
                child: Icon(
                  Icons.check_circle_outline,
                  color: Colors.white,
                  size: 150.0,
                ),
              ),
              const SizedBox(height: 20.0),
              Text(
                message!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.white),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0))),
            ),
            onPressed: onContinue,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                Label.continueButton,
                style: TextStyle(
                  color: Colors.indigo[600],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
