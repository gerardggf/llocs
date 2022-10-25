import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:llocz/screens/informacion.dart';

import '../const.dart';
import '../main.dart';
import '../utils.dart';
import 'forgotpswd.dart';

class LoginWidget extends StatefulWidget {
  final VoidCallback onClickedSignUp;
  const LoginWidget({Key? key, required this.onClickedSignUp})
      : super(key: key);

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final emailController = TextEditingController();
  final contraController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(kPadding),
            child: Column(children: <Widget>[
              const Text(
                "Iniciar sesión",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Correo electrónico",
                ),
              ),
              TextField(
                controller: contraController,
                decoration: const InputDecoration(labelText: "Contraseña"),
                obscureText: true,
              ),
              const SizedBox(height: 18),
              ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(40)),
                  icon: const Icon(Icons.lock_open, size: 25),
                  label: const Text(
                    "Iniciar sesión",
                    style: TextStyle(fontSize: 18),
                  ),
                  onPressed: signIn),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                child: const Text("¿Has olvidado la contraseña?",
                    style: TextStyle(
                        color: Colors.blueAccent,
                        decoration: TextDecoration.underline,
                        fontSize: 16)),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ForgotPasswordScreen()));
                },
              ),
              const SizedBox(
                height: 20,
              ),
              RichText(
                  text: TextSpan(
                      text: "Si no tienes cuenta aún:  ",
                      style: const TextStyle(color: Colors.black, fontSize: 17),
                      children: [
                    TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = widget.onClickedSignUp,
                        text: "Regístrate aquí",
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
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => const InformacionScreen()))))
            ])));
  }

  Future signIn() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: contraController.text.trim());
      Utils.showSnackBar("Sesión iniciada como ${emailController.text}");
    } on FirebaseAuthException catch (e) {
      // ignore: avoid_print
      print(e);
      Utils.showSnackBar(e.message);
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
