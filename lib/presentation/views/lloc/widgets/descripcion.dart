import 'package:flutter/material.dart';

import '../../../routes/routes.dart';
import '../../../../domain/const.dart';

class Descripcion extends StatelessWidget {
  const Descripcion({
    Key? key,
    required this.autor,
    required this.correo,
    required this.desc,
  }) : super(key: key);

  final String autor;
  final String correo;
  final String desc;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Container(
        color: kColorP.withOpacity(kOpacity),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kPadding),
              child: Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  child: RichText(
                    text: TextSpan(
                      text: autor,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: kFSize1,
                          color: Colors.black),
                      children: [
                        TextSpan(
                          text: " $desc",
                          style: const TextStyle(
                              fontWeight: FontWeight.normal, fontSize: kFSize1),
                        ),
                      ],
                    ),
                  ),
                  onTap: () => Navigator.pushNamed(
                    context,
                    Routes.otrosllocs,
                    arguments: [correo, autor],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
