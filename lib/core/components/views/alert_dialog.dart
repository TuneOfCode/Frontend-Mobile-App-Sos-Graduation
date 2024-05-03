import 'package:flutter/material.dart';

class AlertDialogBase extends StatelessWidget {
  final Widget title;
  final Widget content;
  final List<Widget>? actions;
  const AlertDialogBase({
    super.key,
    required this.title,
    required this.content,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title,
      content: content,
      actions: actions,
    );
  }
}
