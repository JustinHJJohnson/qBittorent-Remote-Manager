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

String formatTime(int seconds) {
  String output = '';

  if (seconds != 8640000) {
    if (seconds >= 3600) {
      int temp = seconds ~/ 3600;
      output += '${temp}h';
      seconds -= temp * 3600;
    }
    if (seconds >= 60) {
      int temp = seconds ~/ 60;
      output += '${temp}m';
      seconds -= temp * 60;
    }
    
    output += '${seconds}s';
  }
  else output = 'Done';

  return output;
}

String formatBytesPerSecond(int speed) {
  String output = '';

  if (speed < 1024)  output = '$speed B/s';
  else if (speed < 104858) output = '${(speed / 1024).toStringAsFixed(2)} KB/s';
  else output = '${(speed / 1048576).toStringAsFixed(2)} MB/s';

  return output;
}

String formatSize(int size) {
  String output = '';

  if (size < 104858) output = '${(size / 1024).toStringAsFixed(2)} KB';
  else if (size < 1073741824) output = '${(size / 1048576).toStringAsFixed(2)} MB';
  else output = '${(size / 1073741824).toStringAsFixed(2)} GB';

  return output;
}