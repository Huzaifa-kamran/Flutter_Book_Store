import 'package:flutter/material.dart';

// Define an enum for snackbar types
enum SnackbarType { success, error }

class CustomSnackbar {
  // Method to show a snackbar
  static void showSnackbar(
    BuildContext context,
    String message, {
    SnackbarType type = SnackbarType.error,
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    // Define the background color based on the snackbar type
    Color backgroundColor =
        type == SnackbarType.success ? Colors.green : Colors.red;

    // Create the snackbar
    final snackbar = SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
      duration: const Duration(seconds: 2),
      action: actionLabel != null
          ? SnackBarAction(
              label: actionLabel,
              onPressed: onActionPressed ?? () {},
            )
          : null,
    );

    // Show the snackbar
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}
