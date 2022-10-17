import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../const.dart';
import '../main.dart';
import '../utils.dart';

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
            ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(40)),
                icon: const Icon(Icons.arrow_forward, size: 25),
                label: const Text(
                  "Registrarse",
                  style: TextStyle(fontSize: 18),
                ),
                onPressed: register),
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
                ]))
          ])),
    ));
  }

  Future register() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: contraController.text.trim());
      FirebaseAuth.instance.currentUser?.updateDisplayName(
          emailController.text.substring(0, emailController.text.indexOf('@')));
    } on FirebaseAuthException catch (e) {
      // ignore: avoid_print
      print(e);
      Utils.showSnackBar(e.message);
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
