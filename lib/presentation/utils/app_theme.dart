import 'package:flutter/material.dart';
import 'package:llocs/domain/const.dart';

import 'material_color_generator.dart';

ThemeData getThemeData(BuildContext context) {
  return ThemeData(
    primarySwatch: generateMaterialColor(
      kColorP,
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
    ),
    appBarTheme: AppBarTheme(
      //color icono y texto por defecto
      iconTheme: const IconThemeData(
        color: kColorS,
      ),
      titleTextStyle: const TextStyle(
          color: kColorS, fontWeight: FontWeight.bold, fontSize: kFSize1),
      //sombra y bordes
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
    ),
  );
}
