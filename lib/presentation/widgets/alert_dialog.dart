import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog(
      {super.key,
      required this.onPressedYes,
      required this.title,
      required this.content,
      this.textPressSYes = "Sí"});

  final VoidCallback onPressedYes;
  final String title;
  final String content;
  final String textPressSYes;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: onPressedYes,
          child: Text(textPressSYes),
        ),
      ],
    );
  }
}
