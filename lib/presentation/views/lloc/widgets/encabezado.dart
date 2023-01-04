import 'package:flutter/material.dart';

import '../../../routes/routes.dart';
import '../../../../domain/const.dart';

class Encabezado extends StatelessWidget {
  const Encabezado({
    Key? key,
    required this.nombre,
    required this.autor,
    required this.categoria,
    required this.ubicacion,
    required this.correo,
    required this.fechaPubl,
  }) : super(key: key);

  final String nombre;
  final String autor;
  final String categoria;
  final String ubicacion;
  final String correo;
  final String fechaPubl;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Container(
        color: kColorP.withOpacity(kOpacity),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: kPadding),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 3,
                    child: FittedBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            nombre,
                            maxLines: 2,
                            style: const TextStyle(
                                fontSize: 27, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "$categoria en $ubicacion",
                            style: const TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: kFSize1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    flex: 1,
                    child: FittedBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            child: Text(
                              autor,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            onTap: () => Navigator.pushNamed(
                              context,
                              Routes.otrosllocs,
                              arguments: [correo, autor],
                            ),
                          ),
                          Text(
                            "${fechaPubl.substring(0, 10)} a las ${fechaPubl.substring(11, fechaPubl.length)}",
                            style: const TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
