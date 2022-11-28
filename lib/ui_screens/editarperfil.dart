import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:llocs/ui_screens/auth/forgotpswd.dart';
import 'package:llocs/ui_screens/perfil/fotoperfil.dart';
import 'package:llocs/ui_screens/perfil/pantallas_loggeo.dart';

import '../utils/alert_dialog.dart';
import '../utils/const.dart';
import '../main.dart';
import '../utils/snack_bar.dart';
import '../widgets_globales/bottom_nav_bar.dart';

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
                              ? 'Mínimo 4 carácteres. Se aceptan: ".-_"'
                              : null,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextButton.icon(
                            style: TextButton.styleFrom(
                                minimumSize: const Size.fromHeight(40)),
                            icon: const Icon(Icons.save, size: 25),
                            label: const Text(
                              "Actualizar nombre de usuario",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              final isValid = formKey.currentState!.validate();
                              if (!isValid) return;
                              if (isValid) {
                                showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        CustomAlertDialog(
                                          title: 'Cambiar nombre de usuario',
                                          content:
                                              "¿Quieres cambiar tu nombre de usuario a '${nombreController.text}?'",
                                          onPressedYes: () {
                                            Navigator.pop(context, 'OK');
                                            guardarCambiosP();

                                            setState(() {
                                              user?.displayName;
                                            });
                                          },
                                        ));
                              }
                            }),
                        const SizedBox(
                          height: 20,
                        ),
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Actualiza tu foto de perfil:",
                            style: TextStyle(fontSize: kFSize1),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextButton.icon(
                            style: TextButton.styleFrom(
                              minimumSize: const Size.fromHeight(45),
                            ),
                            icon: const Icon(Icons.photo_camera_back, size: 25),
                            label: const Text(
                              "Subir/ Cambiar foto de perfil",
                              style: TextStyle(
                                  fontSize: kFSize1,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const FotoPerfilScreen()))),
                        const SizedBox(
                          height: 20,
                        ),
                        if (user?.photoURL != null)
                          CircleAvatar(
                            radius: 50,
                            child: ClipOval(
                              child: Image.network(
                                user?.photoURL ??
                                    "https://i.picsum.photos/id/9/250/250.jpg?hmac=tqDH5wEWHDN76mBIWEPzg1in6egMl49qZeguSaH9_VI",
                                width: 150,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        if (user?.photoURL == null)
                          CircleAvatar(
                            radius: 50,
                            child: Text(user!.displayName![0].toUpperCase(),
                                style: const TextStyle(
                                    fontSize: 30, color: Colors.white)),
                          ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Cambia tu contraseña:",
                            style: TextStyle(
                                fontSize: kFSize1, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextButton.icon(
                            style: TextButton.styleFrom(
                              minimumSize: const Size.fromHeight(45),
                            ),
                            icon: const Icon(Icons.restart_alt, size: 25),
                            label: const Text(
                              "Restablecer contraseña",
                              style: TextStyle(
                                  fontSize: kFSize1,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ForgotPasswordScreen()))),
                        const SizedBox(
                          height: 25,
                        ),
                        const Divider(),
                        const SizedBox(
                          height: 10,
                        ),
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Borrar cuenta",
                            style: TextStyle(fontSize: kFSize1 + 2),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text(
                          'Se borrará toda tu información personal, a excepción de los lugares que has creado en la aplicación. Si quieres eliminar los lugares que tienes publicados, por favor elimínalos manualmente o ponte en contacto con "qallocs@gmail.com".',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                                minimumSize: const Size.fromHeight(30),
                                backgroundColor: Colors.red),
                            icon: const Icon(Icons.delete, size: 20),
                            label: const Text(
                              "Eliminar cuenta",
                              style: TextStyle(fontSize: 18),
                            ),
                            onPressed: () => showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                      title: const Text('Eliminar cuenta'),
                                      content: const Text(
                                        '¿Seguro que quieres borrar tu cuenta? Ten en cuenta que los lugares que has publicado en la aplicación no serán eliminados. Si los quieres eliminar, por favor elimínalos manualmente o ponte en contacto con "qallocs@gmail.com".',
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, 'Cancel'),
                                          child: const Text('Cancelar'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context, 'OK');
                                            FirebaseFirestore.instance
                                                .collection('llocs')
                                                .where('correo',
                                                    isEqualTo: user?.email)
                                                .get()
                                                .then((snapshot) {
                                              for (DocumentSnapshot ds
                                                  in snapshot.docs) {
                                                ds.reference.delete();
                                              }
                                            });
                                            user?.delete();
                                            // try {
                                            //   final docUserInfo = FirebaseFirestore
                                            //       .instance
                                            //       .collection("usuarios")
                                            //       .doc(user?.uid);
                                            //   docUserInfo.delete();
                                            // } catch (e) {
                                            //   // ignore: avoid_print
                                            //   print(e);
                                            // }
                                            Navigator.of(context)
                                                .pushAndRemoveUntil(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const PantallasLoggeo()),
                                                    (Route route) => false);
                                          },
                                          child: const Text('Sí'),
                                        ),
                                      ],
                                    ))),
                      ],
                    )))),
        bottomNavigationBar: const CustomBottomNavBar());
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
        MaterialPageRoute(builder: (context) => const PantallasLoggeo()),
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
