import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:llocz/screens/forgotpswd.dart';
import 'package:llocz/screens/home.dart';
import 'package:llocz/screens/perfil.dart';

import '../const.dart';
import '../main.dart';
import '../utils.dart';

class EditarperfilScreen extends StatefulWidget {
  const EditarperfilScreen({super.key});

  @override
  State<EditarperfilScreen> createState() => _EditarperfilScreenState();
}

class _EditarperfilScreenState extends State<EditarperfilScreen> {
  final formKey = GlobalKey<FormState>();
  final nombreController = TextEditingController();

  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Editar perfil",
          ),
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(kPadding),
                child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        RichText(
                            text: TextSpan(
                                text: "Has iniciado sesión como ",
                                style: const TextStyle(
                                    fontSize: kFSize1, color: Colors.black),
                                children: [
                              TextSpan(
                                text: user?.email,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ])),
                        const SizedBox(
                          height: 15,
                        ),
                        RichText(
                            text: TextSpan(
                                text:
                                    "Puedes cambiarte el nombre de usuario de ",
                                style: const TextStyle(
                                    fontSize: kFSize1, color: Colors.black),
                                children: [
                              TextSpan(
                                text: user?.displayName ?? "",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: kFSize1),
                              ),
                              const TextSpan(
                                text: " a:",
                                style: TextStyle(fontSize: kFSize1),
                              ),
                            ])),
                        TextFormField(
                          controller: nombreController,
                          decoration: const InputDecoration(
                              labelText: "Nuevo nombre de usuario"),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) => value != null &&
                                      value.length < 4 ||
                                  value != null &&
                                      value.contains(RegExp(
                                          r'[+!@#%^&*(),?":;{}|/<>®©£¢€¥∆¶×~=°℅™÷π√•`$]'))
                              ? "Mínimo 4 carácteres y sin espacios. Solo se aceptan '.-_'"
                              : null,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                                minimumSize: const Size.fromHeight(40)),
                            icon: const Icon(Icons.save, size: 25),
                            label: const Text(
                              "Guardar cambios",
                              style: TextStyle(fontSize: 18),
                            ),
                            onPressed: () {
                              final isValid = formKey.currentState!.validate();
                              if (!isValid) return;
                              if (isValid) {
                                showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                          title: const Text(
                                              'Cambiar nombre de usuario'),
                                          content: Text(
                                              "¿Quieres cambiar tu nombre de usuario a '${nombreController.text}?'"),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () => Navigator.pop(
                                                  context, 'Cancel'),
                                              child: const Text('Cancelar'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context, 'OK');
                                                guardarCambiosP();

                                                setState(() {
                                                  user?.displayName;
                                                });
                                              },
                                              child: const Text('Sí'),
                                            ),
                                          ],
                                        ));
                              }
                            }),
                        const SizedBox(
                          height: 20,
                        ),
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Cambia tu contraseña:",
                            style: TextStyle(fontSize: kFSize1),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(45),
                            ),
                            icon: const Icon(Icons.restart_alt, size: 25),
                            label: const Text(
                              "Restablecer contraseña",
                              style: TextStyle(fontSize: 18),
                            ),
                            onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ForgotPasswordScreen()))),
                        const SizedBox(
                          height: 35,
                        ),
                        const Text(
                          "Ante cualquier duda o propuesta contacta con el siguiente correo electrónico: qallocs@gmail.com",
                          style: TextStyle(fontStyle: FontStyle.italic),
                        )
                      ],
                    )))),
        bottomNavigationBar: bottomB(context));
  }

  Future guardarCambiosP() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));

    try {
      await updateMisLlocS();
      await FirebaseAuth.instance.currentUser
          ?.updateDisplayName(nombreController.text);

      Utils.showSnackBar("Se han guardado correctamente los cambios");
    } on FirebaseAuthException catch (e) {
      // ignore: avoid_print
      print(e);
      Utils.showSnackBar(e.message);
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
    setState(() {
      user?.displayName;
    });
    // ignore: use_build_context_synchronously
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const PerfilScreen()),
        (Route route) => false);
  }

  Future updateMisLlocS() async {
    FirebaseFirestore.instance
        .collection("llocs")
        .where("correo", isEqualTo: user?.email ?? "Anónimo")
        .get()
        .then((QuerySnapshot querySnapshot) => {
              // ignore: avoid_function_literals_in_foreach_calls
              querySnapshot.docs.forEach((doc) {
                FirebaseFirestore.instance
                    .collection("llocs")
                    .doc(doc['id'])
                    .update({'autor': nombreController.text});
              })
            });
  }
}
