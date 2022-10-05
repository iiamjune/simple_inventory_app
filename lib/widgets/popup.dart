import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/success.dart';

class Popup {
  Popup(this.context);
  final BuildContext context;

  showSuccess({String? message, VoidCallback? onTap}) {
    showModalBottomSheet(
        isScrollControlled: true,
        isDismissible: false,
        enableDrag: false,
        context: context,
        builder: (context) {
          return Success(
            message: message,
            onContinue: onTap,
          );
        });
  }
}
