import 'package:flutter/material.dart';

import '../constants/labels.dart';

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({super.key, required this.title, required this.content});
  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        ElevatedButton(
          child: const Text(Label.yes),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
        ElevatedButton(
          child: const Text(Label.no),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
      ],
    );
  }
}
