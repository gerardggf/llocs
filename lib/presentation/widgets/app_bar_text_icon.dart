import 'package:flutter/material.dart';

import '../../domain/const.dart';

class CustomTextIcon extends StatelessWidget {
  const CustomTextIcon(
      {super.key,
      required this.onPressed,
      required this.iconData,
      required this.text});

  final VoidCallback onPressed;
  final IconData iconData;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8).copyWith(right: 5),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
            color: kColorS, borderRadius: BorderRadius.circular(20)),
        child: TextButton.icon(
          onPressed: onPressed,
          icon: Icon(
            iconData,
            color: kColorP,
            size: 20,
          ),
          label: Text(
            text,
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: kFSize1, color: kColorP),
          ),
        ),
      ),
    );
  }
}
