import 'package:flutter/material.dart';

class CustomSnackbar {
  static void showSnackbar(BuildContext context, String message,String type) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: type == "success"?Colors.green:Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
