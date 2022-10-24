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
            "assets/img/logo_app_grande.png",
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

                return GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 3.0,
                  childAspectRatio: 2 / 2.5,
                  mainAxisSpacing: 3.0,
                  children: llocs.map(buildLlocsH).toList(),
                );

                //ListView(children: llocs.map(buildLlocs).toList());
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
          header: GridTileBar(
            backgroundColor: Colors.white70,
            title: Text(
              lloc.nombre,
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
          footer: GridTileBar(
            backgroundColor: Colors.white70,
            title: Text(
              "${lloc.categoria} en ${lloc.ubicacion}",
              style: const TextStyle(color: Colors.black),
            ),
            subtitle:
                Text(lloc.autor, style: const TextStyle(color: Colors.black54)),
          ),
          child: Image.network(
            lloc.urlImagen,
            width: 55,
            height: 100,
            fit: BoxFit.cover,
          ),
        )),
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
