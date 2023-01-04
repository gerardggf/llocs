import 'package:flutter/material.dart';
import 'package:llocs/domain/const.dart';
import '../routes/routes.dart';

class CustomAppLogo extends StatelessWidget {
  const CustomAppLogo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () => Navigator.pushNamed(
            context,
            Routes.informacion,
          ),
          child: Image.asset(
            "assets/img/app_logo_sin_fondo.png",
            height: 40,
            width: 40,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        const Text(
          "llocs",
          style: TextStyle(
              fontSize: 30, color: kColorS, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
