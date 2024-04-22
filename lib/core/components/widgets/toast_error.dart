import 'package:flutter/material.dart';

class ToastError extends StatelessWidget {
  final String message;
  const ToastError({
    super.key,
    required this.message,
  });

  @override
  SnackBar build(BuildContext context) {
    return SnackBar(
      content: Text(
        message,
        style: TextStyle(
          color: Colors.red[500],
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
      backgroundColor: Colors.white,
    );
  }
}
