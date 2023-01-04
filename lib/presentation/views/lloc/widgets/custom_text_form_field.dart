import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField(
      {super.key,
      required this.controller,
      required this.iconData,
      required this.label,
      required this.maxCaracteres,
      this.hintText});

  final TextEditingController controller;
  final IconData iconData;
  final String label;
  final String? hintText;
  final int maxCaracteres;

  @override
  Widget build(BuildContext context) {
    String? validarCampo(value, maxCaracteres) {
      if (value != null && value.isEmpty ||
          value != null && value.length >= maxCaracteres) {
        return "El campo debe contener entre 1 y $maxCaracteres carácteres";
      } else {
        return null;
      }
    }

    return TextFormField(
      keyboardType: TextInputType.multiline,
      maxLines: null,
      controller: controller,
      decoration: InputDecoration(
        icon: Icon(iconData),
        labelText: label,
        hintText: hintText,
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) => validarCampo(
        value,
        maxCaracteres,
      ),
    );
  }
}
