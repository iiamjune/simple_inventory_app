import 'package:flutter/material.dart';

class PageFooter extends StatelessWidget {
  const PageFooter(
      {super.key,
      required this.label,
      required this.navigation,
      required this.buttonLabel});
  final String label;
  final VoidCallback navigation;
  final String buttonLabel;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      alignment: WrapAlignment.center,
      direction: Axis.vertical,
      spacing: -10.0,
      children: <Widget>[
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
        TextButton(
          onPressed: navigation,
          child: Text(
            buttonLabel,
            style: TextStyle(color: Colors.indigo[600]),
          ),
        ),
      ],
    );
  }
}
