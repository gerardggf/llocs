import 'package:flutter/material.dart';
import 'package:llocs/utils/const.dart';

class AppBarIcons extends StatelessWidget {
  const AppBarIcons(
      {super.key, required this.iconData, required this.onPressed});

  final IconData iconData;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8).copyWith(right: 3),
      child: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: kColorS,
        ),
        child: IconButton(
            icon: Icon(
              iconData,
              size: 20,
              color: kColorP,
            ),
            onPressed: onPressed),
      ),
    );
  }
}
