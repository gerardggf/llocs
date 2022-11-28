import 'package:flutter/material.dart';

class Utils {
  static final messengerKey = GlobalKey<ScaffoldMessengerState>();

  static showSnackBar(String? text) {
    var texto = text;

    if (text == null) return;
    switch (text) {
      case "Given String is empty or null":
        {
          texto = "Por favor rellena el/los campo/s vacío/s.";
        }
        break;
      case "The email address is badly formatted.":
        {
          texto = "El correo electrónico está mal formateado";
        }
        break;
      case "The password is invalid or the user does not have a password.":
        {
          texto = "La contraseña es incorrecta.";
        }
        break;
      case "The email address is already in use by another account.":
        {
          texto = "El correo electrónico ya es utilizado por otra cuenta";
        }
        break;
      case "There is no user record corresponding to this identifier. The user may have been deleted.":
        {
          texto =
              "No hay ningún usuario que corresponda a este correo electrónico.";
        }
        break;
    }

    final snackBar = SnackBar(
      content: Text(
        texto!,
        style: const TextStyle(color: Colors.black),
      ),
      backgroundColor: Colors.greenAccent,
    );

    messengerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
