import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:llocz/screens/buscarpor.dart';
import 'package:llocz/screens/perfil.dart';

import '../models.dart';
import 'clloc.dart';
import 'lloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Image.asset(
            "assets/img/logo_app.png",
            height: 350,
            width: 130,
          ),
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
            stream: leerLlocS(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text("Algo ha ido mal: ${snapshot.error}");
              } else if (snapshot.hasData) {
                final llocs = snapshot.data!;

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

  Stream<List<Lloc>> leerLlocS() => FirebaseFirestore.instance
      .collection('llocs')
      .orderBy("fechaPubl", descending: true)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Lloc.fromJson(doc.data())).toList());
}

var indexB = 0;

Widget bottomB(BuildContext context) => BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_filled),
          label: "Lugares",
        ),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: "Buscar"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil"),
      ],
      onTap: (value) {
        switch (value) {
          case 0:
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const HomeScreen()),
                (Route route) => false);

            break;
          case 1:
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => const BuscarPorScreen()),
                (Route route) => false);
            break;
          case 2:
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const PerfilScreen()),
                (Route route) => false);
            break;
        }
        indexB = value;
      },
      currentIndex: indexB,
    );
