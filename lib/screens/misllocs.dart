import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:llocz/const.dart';

import '../models.dart';
import 'clloc.dart';
import 'home.dart';
import 'lloc.dart';

class MisLlocs extends StatefulWidget {
  const MisLlocs({Key? key}) : super(key: key);

  @override
  State<MisLlocs> createState() => _MisLlocsState();
}

class _MisLlocsState extends State<MisLlocs> {
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("${user!.displayName}",
              style: const TextStyle(
                fontSize: 20,
              )),
          actions: <Widget>[
            if (user?.email != null)
              IconButton(
                  icon: const Icon(
                    Icons.post_add,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: ((context) => const CLlocScreen())));
                  })
          ],
        ),
        body: StreamBuilder<List<Lloc>>(
            stream: leerMisLlocS(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text(
                  "Algo ha ido mal: ${snapshot.error}",
                  style: const TextStyle(color: Colors.white),
                );
              } else if (snapshot.hasData) {
                final llocs = snapshot.data!;
                if (llocs.isEmpty) {
                  return const Center(
                      child: Padding(
                    padding: EdgeInsets.all(kPadding),
                    child: Text(
                      "No tienes ningún lugar creado. Pulsa en el símbolo '+' para crear uno.",
                      style: TextStyle(fontSize: kFSize1),
                    ),
                  ));
                }
                return ListView(children: llocs.map(buildLlocs).toList());
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
        bottomNavigationBar: bottomB(context));
  }

  Widget buildLlocs(Lloc lloc) => ListTile(
        leading: Image.network(lloc.urlImagen, width: 50, height: 100),
        title: Text(lloc.nombre),
        isThreeLine: true,
        subtitle: RichText(
          text: TextSpan(
              text: "${lloc.categoria} en ${lloc.ubicacion}\n",
              style: const TextStyle(
                  color: Color.fromARGB(255, 77, 99, 110),
                  fontWeight: FontWeight.w500),
              children: [
                TextSpan(
                    text: lloc.autor,
                    style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey)),
              ]),
        ),
        trailing: Text(
          "${lloc.fechaPubl.substring(0, 10)}\n${lloc.fechaPubl.substring(10, lloc.fechaPubl.length)}",
          textAlign: TextAlign.end,
        ),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => LlocScreen(
              idLloc: lloc.id,
            ),
          ));
        },
      );

  Stream<List<Lloc>> leerMisLlocS() => FirebaseFirestore.instance
      .collection('llocs')
      .where("correo", isEqualTo: user?.email ?? "Anónimo")
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Lloc.fromJson(doc.data())).toList());
}
