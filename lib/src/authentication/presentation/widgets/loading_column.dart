import 'package:flutter/material.dart';

class LoadingColumn extends StatelessWidget {
  final String message;

  const LoadingColumn({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 10),
          Text('$message...'),
        ],
      ),
    );
  }
}
