import 'package:flutter/material.dart';

/// Displays an elevated, rounded snack bar with the primary theme colour as the background colour.
/// code is referenced from https://www.geeksforgeeks.org/flutter-snackbar/
void showCustomSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message, textAlign: TextAlign.center),
    elevation: 10,
    behavior: SnackBarBehavior.floating,
    margin: EdgeInsets.all(10),
    backgroundColor: Theme.of(context).primaryColor,
  ));
}