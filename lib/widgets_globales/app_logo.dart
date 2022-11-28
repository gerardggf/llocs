import 'package:flutter/material.dart';

import '../informacion.dart';

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
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: ((context) => const InformacionScreen()))),
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
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
