import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:llocs/utils/const.dart';

import '../../utils/snack_bar.dart';
import '../perfil/perfil.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({Key? key}) : super(key: key);

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? tempor;

  @override
  void initState() {
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerified) {
      sendVerificationEmail();

      tempor = Timer.periodic(
          const Duration(seconds: 2), (_) => checkEmailVerified());
    }
  }

  @override
  void dispose() {
    tempor?.cancel();

    super.dispose();
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) {
      tempor?.cancel();

      Utils.showSnackBar("Registrado correctamente");
    }
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      setState(() {
        canResendEmail = false;
      });
      await Future.delayed(const Duration(seconds: 5));
      setState(() {
        canResendEmail = true;
      });
    } catch (e) {
      Utils.showSnackBar(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? const PerfilScreen()
      : SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(kPadding),
              child: Column(children: [
                Text(
                  "Verifica tu correo electrónico\n",
                  style: Theme.of(context).textTheme.headline5,
                ),
                const Text(
                    "Te hemos mandado un correo electrónico para verificar tu cuenta.\n\nSi no lo recibes, comprueba tu carpeta de Spam.\n\nUna vez haya sido verificado, se iniciará sesión automáticamente",
                    style: TextStyle(fontSize: 15)),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(40)),
                  icon: const Icon(Icons.email_outlined, size: 25),
                  label: const Text(
                    "Reenviar correo",
                    style: TextStyle(fontSize: 18),
                  ),
                  onPressed: canResendEmail ? sendVerificationEmail : null,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextButton(
                  child: const Text("Cancelar", style: TextStyle(fontSize: 24)),
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                  },
                )
              ])));
}
