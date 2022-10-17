import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:llocz/screens/home.dart';

import '../const.dart';
import '../utils.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Restablecer contraseña"),
      ),
      body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(kPadding),
              child: Form(
                key: formKey,
                child: Column(children: <Widget>[
                  const Text(
                    "Recibe un correo electrónico para restablecer tu contraseña",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: emailController,
                    decoration:
                        const InputDecoration(labelText: "Correo electrónico"),
                    textInputAction: TextInputAction.done,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (email) =>
                        email != null && !EmailValidator.validate(email)
                            ? "Introduce un correo electrónico válido"
                            : null,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(40)),
                    icon: const Icon(Icons.email_outlined, size: 25),
                    label: const Text(
                      "Restablecer contraseña",
                      style: TextStyle(fontSize: 18),
                    ),
                    onPressed: resetpswd,
                  )
                ]),
              ))),
      bottomNavigationBar: bottomB(context),
    );
  }

  Future resetpswd() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());

      Utils.showSnackBar(
          "Correo electrónico enviado. Si no recibes nada en pocos minutos, comprueba la bandeja de Spam");

      // ignore: use_build_context_synchronously
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      // ignore: avoid_print
      print(e);
      Utils.showSnackBar(e.message);
      Navigator.of(context).pop();
    }
  }
}
