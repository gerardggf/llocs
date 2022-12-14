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
                return GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 3.0,
                  mainAxisSpacing: 3.0,
                  children: llocs.map(buildLlocsH).toList(),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
        bottomNavigationBar: bottomB(context));
  }

  Widget buildLlocsH(Lloc lloc) => GestureDetector(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => LlocScreen(
            idLloc: lloc.id,
          ),
        )),
        child: (GridTile(
          footer: GridTileBar(
            backgroundColor: Colors.white70,
            title: Text(
              lloc.nombre,
              style: const TextStyle(color: Colors.black),
            ),
            subtitle: Text("${lloc.categoria} en ${lloc.ubicacion}",
                style: const TextStyle(color: Colors.black54)),
          ),
          child: Image.network(
            lloc.urlImagen,
            width: 55,
            height: 100,
            fit: BoxFit.cover,
          ),
        )),
      );

  Stream<List<Lloc>> leerMisLlocS() => FirebaseFirestore.instance
      .collection('llocs')
      .where("correo", isEqualTo: user?.email ?? "Anónimo")
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Lloc.fromJson(doc.data())).toList());
}
