import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:llocz/const.dart';
import 'package:llocz/screens/home.dart';
import 'package:llocz/screens/otrosllocs.dart';
import 'package:llocz/screens/perfil.dart';

import '../models.dart';
import 'elloc.dart';

class LlocScreen extends StatefulWidget {
  const LlocScreen({Key? key, required this.idLloc}) : super(key: key);

  final String idLloc;

  @override
  State<LlocScreen> createState() => _LlocScreenState();
}

class _LlocScreenState extends State<LlocScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  final usuarioLloc = FirebaseFirestore.instance.collection("fotoPerfil");
  String fotoPUser = "";

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Lloc?>(
      future: leerLloc(widget.idLloc),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Algo ha ido mal: ${snapshot.error}");
        } else if (snapshot.hasData) {
          final lloc = snapshot.data;

          return lloc == null
              ? const Center(child: Text("No existe el lugar"))
              : buildLloc(context, lloc);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget buildLloc(BuildContext context, Lloc lloc) => Scaffold(
        appBar: AppBar(
          title: Text(
            lloc.nombre,
          ),
          actions: <Widget>[
            if (user?.email == lloc.correo)
              IconButton(
                  icon: const Icon(
                    Icons.edit,
                    size: 25,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: ((context) => ELlocScreen(lloc.id))));
                  }),
            if (user?.email == lloc.correo)
              IconButton(
                  onPressed: () {
                    showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              title: const Text('Borrar lugar'),
                              content: const Text(
                                  '¿Seguro que deseas eliminar este lugar?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, 'Cancel'),
                                  child: const Text('Cancelar'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, 'OK');

                                    final docLloc = FirebaseFirestore.instance
                                        .collection("llocs")
                                        .doc(lloc.id);
                                    docLloc.delete();
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Sí'),
                                ),
                              ],
                            ));
                  },
                  icon: const Icon(Icons.delete)),
            if (user?.email != lloc.correo)
              IconButton(
                  icon: const Icon(
                    Icons.person_search,
                    size: 25,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: ((context) => OtrosLlocs(
                            correoUser: lloc.correo, nombreUser: lloc.autor))));
                  }),
          ],
        ),
        body: SingleChildScrollView(
            child: Align(
                alignment: Alignment.topLeft,
                child: Column(children: [
                  if (user?.email == null)
                    GestureDetector(
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const PerfilScreen())),
                        child: const Padding(
                            padding: EdgeInsets.all(kPadding),
                            child: Text(
                              "Registrate o inicia sesión para poder compartir lugares",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                            ))),
                  if (user?.email != null)
                    const SizedBox(
                      height: kPadding,
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: kPadding),
                    child: Container(
                      alignment: Alignment.topLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lloc.nombre,
                            style: const TextStyle(
                                fontSize: 27, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${lloc.categoria} en ${lloc.ubicacion}",
                            style: const TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: kFSize1,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: kPadding),
                    child:
                        // Row(
                        //   children: [
                        //     Flexible(
                        //         flex: 1,
                        //         child: Column(children: [
                        //           if (user?.photoURL == "")
                        //             CircleAvatar(
                        //               radius: 25,
                        //               child: Text(lloc.autor[0].toUpperCase(),
                        //                   style: const TextStyle(
                        //                       fontSize: 20, color: Colors.white)),
                        //             ),
                        //           if (user?.photoURL != "")
                        //             CircleAvatar(
                        //                 radius: 25,
                        //                 child: ClipOval(
                        //                   child: Image.network(
                        //                     fotoPUser,
                        //                     width: 100,
                        //                     height: 100,
                        //                     fit: BoxFit.cover,
                        //                   ),
                        //                 ))
                        //         ])),
                        //     const SizedBox(
                        //       width: 10,
                        //     ),
                        //     Flexible(
                        //       flex: 4,
                        //       child:
                        Container(
                      alignment: Alignment.topLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            child: Text(
                              lloc.autor,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => OtrosLlocs(
                                        correoUser: lloc.correo,
                                        nombreUser: lloc.autor))),
                          ),
                          Text(
                            "Publicado el ${lloc.fechaPubl.substring(0, 10)} a las ${lloc.fechaPubl.substring(11, lloc.fechaPubl.length)}",
                            style: const TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                    //     )
                    //   ],
                    // ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (lloc.urlImagen != "")
                    Image.network(
                      lloc.urlImagen,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: kPadding),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: GestureDetector(
                          child: RichText(
                              text: TextSpan(
                                  text: lloc.autor,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: kFSize1,
                                      color: Colors.black),
                                  children: [
                                TextSpan(
                                  text: " ${lloc.desc}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: kFSize1),
                                ),
                              ])),
                          onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => OtrosLlocs(
                                      correoUser: lloc.correo,
                                      nombreUser: lloc.autor)))),
                    ),
                  ),
                  const SizedBox(
                    height: kPadding,
                  ),
                ]))),
        bottomNavigationBar: bottomB(context),
      );

  Future<Lloc?> leerLloc(idLloc) async {
    final docLloc = FirebaseFirestore.instance.collection("llocs").doc(idLloc);
    final snapshot = await docLloc.get();

    if (snapshot.exists) {
      return Lloc.fromJson(snapshot.data()!);
    }
    return null;
  }
}
