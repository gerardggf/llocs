import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:llocz/screens/autenticacion.dart';
import 'package:llocz/screens/clloc.dart';
import 'package:llocz/screens/editarperfil.dart';
import 'package:llocz/screens/fotoperfil.dart';
import 'package:llocz/screens/informacion.dart';
import 'package:llocz/screens/verifyemail.dart';

import '../const.dart';
import 'home.dart';
import 'misllocs.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({Key? key}) : super(key: key);

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Perfil",
            style: TextStyle(fontSize: 25),
          ),
        ),
        body: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text("Algo ha ido mal"),
                );
              } else if (snapshot.hasData) {
                return const VerifyEmailScreen();
              } else {
                return const AuthScreen();
              }
            }),
        bottomNavigationBar: bottomB(context));
  }
}

class LoggedWidget extends StatefulWidget {
  const LoggedWidget({Key? key}) : super(key: key);

  @override
  State<LoggedWidget> createState() => _LoggedWidgetState();
}

class _LoggedWidgetState extends State<LoggedWidget> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    super.initState();
    user.photoURL;
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      user.displayName;
      user.photoURL;
    });

    return SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(kPadding),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                    Widget>[
              Row(children: [
                if (user.photoURL != null)
                  GestureDetector(
                      child: CircleAvatar(
                        radius: 40,
                        child: ClipOval(
                          child: Image.network(
                            user.photoURL ??
                                "https://i.picsum.photos/id/9/250/250.jpg?hmac=tqDH5wEWHDN76mBIWEPzg1in6egMl49qZeguSaH9_VI",
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const FotoPerfilScreen()))),
                if (user.photoURL == null)
                  GestureDetector(
                    child: CircleAvatar(
                      radius: 40,
                      child: Text(user.displayName![0].toUpperCase(),
                          style: const TextStyle(
                              fontSize: 30, color: Colors.white)),
                    ),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const FotoPerfilScreen())),
                  ),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.displayName!,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: kFSize1),
                    ),
                    Text(
                      user.email!,
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    ),
                    Text(
                      "Cuenta creada el ${DateFormat("dd/MM/yyyy").format(user.metadata.creationTime ?? DateTime.now())}",
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ]),
              const SizedBox(
                width: 20,
              ),
              const Divider(),
              TextButton.icon(
                  icon: const Icon(
                    Icons.list,
                    size: 25,
                    color: Colors.black,
                  ),
                  label: const Text(
                    "Ver mis publicaciones",
                    textAlign: TextAlign.left,
                    style:
                        TextStyle(fontSize: kFSize1 + 2, color: Colors.black),
                  ),
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const MisLlocs()))),
              TextButton.icon(
                  icon: const Icon(
                    Icons.person,
                    size: 25,
                    color: Colors.black,
                  ),
                  label: const Text(
                    "Editar perfil",
                    style:
                        TextStyle(fontSize: kFSize1 + 2, color: Colors.black),
                  ),
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const EditarperfilScreen()))),
              TextButton.icon(
                  icon: const Icon(
                    Icons.post_add,
                    size: 25,
                    color: Colors.black,
                  ),
                  label: const Text(
                    "Publicar nuevo lugar",
                    textAlign: TextAlign.left,
                    style:
                        TextStyle(fontSize: kFSize1 + 2, color: Colors.black),
                  ),
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const CLlocScreen()))),
              TextButton.icon(
                  icon: const Icon(
                    Icons.info_outline_rounded,
                    size: 25,
                    color: Colors.black,
                  ),
                  label: const Text(
                    "Información",
                    style:
                        TextStyle(fontSize: kFSize1 + 2, color: Colors.black),
                  ),
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const InformacionScreen()))),
              const SizedBox(
                height: 20,
              ),
              const Divider(),
              TextButton.icon(
                  style: TextButton.styleFrom(
                    minimumSize: const Size.fromHeight(40),
                  ),
                  icon: const Icon(
                    Icons.exit_to_app,
                    size: 25,
                    color: Colors.red,
                  ),
                  label: const Text(
                    "Cerrar sesión",
                    style: TextStyle(fontSize: 18, color: Colors.red),
                  ),
                  onPressed: () => showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                            title: const Text('Cerrar sesión'),
                            content:
                                const Text('¿Seguro que deseas cerrar sesión?'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, 'Cancel'),
                                child: const Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context, 'OK');
                                  FirebaseAuth.instance.signOut();
                                },
                                child: const Text('Sí'),
                              ),
                              Container(
                                height: 100,
                              )
                            ],
                          ))),
            ])));
  }
}
