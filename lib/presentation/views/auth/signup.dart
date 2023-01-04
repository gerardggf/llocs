import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/services/auth.dart';
import '../../routes/routes.dart';
import '../../../domain/const.dart';
import '../../../main.dart';
import '../../utils/snack_bar.dart';

class RegisterWidget extends StatefulWidget {
  final VoidCallback onClickedSignUp;
  const RegisterWidget({Key? key, required this.onClickedSignUp})
      : super(key: key);

  @override
  State<RegisterWidget> createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<RegisterWidget> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final contraController = TextEditingController();
  final contraConfirmController = TextEditingController();

  bool aceptarCond = false;

  final Uri _url = Uri.parse(
      'https://sites.google.com/view/ppllocs/t%C3%A9rminos-y-condiciones-de-uso');

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.all(kPadding),
      child: Form(
          key: formKey,
          child: Column(children: <Widget>[
            const Text(
              "Registro",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            TextFormField(
              controller: emailController,
              decoration:
                  const InputDecoration(labelText: "Correo electrónico"),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (email) =>
                  email != null && !EmailValidator.validate(email)
                      ? "Introduce un correo electrónico válido"
                      : null,
            ),
            TextFormField(
              controller: contraController,
              decoration: const InputDecoration(labelText: "Contraseña"),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              obscureText: true,
              validator: (value) => value != null && value.length < 6
                  ? "Introduce mínimo 6 carácteres"
                  : null,
            ),
            TextFormField(
              controller: contraConfirmController,
              decoration:
                  const InputDecoration(labelText: "Confirmar contraseña"),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              obscureText: true,
              validator: (value) =>
                  value != null && value != contraController.text
                      ? "Ambas contraseñas deben coincidir"
                      : null,
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Checkbox(
                    value: aceptarCond,
                    onChanged: (value) {
                      setState(() {
                        aceptarCond = value!;
                      });
                    }),
                Flexible(
                  flex: 8,
                  child: RichText(
                      text: TextSpan(
                          text: "He leído y acepto los",
                          style: const TextStyle(
                              color: Colors.black, fontSize: 16),
                          children: [
                        TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                _launchUrl();
                              },
                            text: " términos y condiciones de servicio.",
                            style: const TextStyle(
                              color: Colors.blueAccent,
                            ))
                      ])),
                ),
              ],
            ),
            const SizedBox(height: 18),
            ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(40)),
                icon: const Icon(Icons.arrow_forward, size: 25),
                label: const Text(
                  "Registrarse",
                  style: TextStyle(fontSize: 18),
                ),
                onPressed: () {
                  if (aceptarCond == false) {
                    Utils.showSnackBar(
                        "Tienes que leer y aceptar los términos y condiciones de uso para poder registrarte");
                  } else {
                    final isValid = formKey.currentState!.validate();
                    if (!isValid) return;
                    Auth().register(
                      context,
                      emailController.text,
                      contraController.text,
                    );
                    navigatorKey.currentState!
                        .popUntil((route) => route.isFirst);
                  }
                }),
            const SizedBox(
              height: 15,
            ),
            RichText(
                text: TextSpan(
                    text: "Ya tengo cuenta:  ",
                    style: const TextStyle(color: Colors.black, fontSize: 18),
                    children: [
                  TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = widget.onClickedSignUp,
                      text: "Iniciar Sesión",
                      style: const TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold))
                ])),
            const SizedBox(
              height: 30,
            ),
            GestureDetector(
              child: Image.asset(
                "assets/img/app_logo_sin_fondo_negro.png",
                height: 100,
                width: 100,
              ),
              onTap: () => Navigator.pushNamed(context, Routes.informacion),
            ),
          ])),
    ));
  }

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }
}
