import 'package:flutter/material.dart';

class ToastSuccess extends StatelessWidget {
  final String message;
  const ToastSuccess({
    super.key,
    required this.message,
  });

  @override
  SnackBar build(BuildContext context) {
    return SnackBar(
      content: Text(
        message,
        style: TextStyle(
          color: Colors.green[600],
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
      backgroundColor: Colors.white,
    );
  }
}
