import 'package:flutter/material.dart';

import '../utils/const.dart';

class CustomItemButton extends StatelessWidget {
  const CustomItemButton(
      {super.key,
      required this.iconData,
      required this.text,
      required this.onPressed,
      this.color = Colors.black});

  final IconData iconData;
  final String text;
  final VoidCallback onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      icon: Icon(
        iconData,
        size: 25,
        color: color,
      ),
      label: Text(
        text,
        textAlign: TextAlign.left,
        style: TextStyle(fontSize: kFSize1 + 2, color: color),
      ),
      onPressed: onPressed,
    );
  }
}
