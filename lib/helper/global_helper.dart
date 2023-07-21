import 'package:flutter/material.dart';

void showSnackBar(
    {required ScaffoldMessengerState snackBar,
    required String message,
    int durationSeconds = 2}) {
  snackBar.showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
    ),
  );
}
