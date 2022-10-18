import 'package:flutter/material.dart';

PreferredSizeWidget pageAppBar(String title) {
  return AppBar(
    backgroundColor: Colors.indigo[600],
    title: Text(title),
    centerTitle: true,
  );
}
