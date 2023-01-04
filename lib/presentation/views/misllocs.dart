import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:llocs/data/services/auth.dart';
import 'package:llocs/presentation/routes/routes.dart';
import 'package:llocs/domain/const.dart';

import '../../domain/models/lloc_model.dart';
import '../widgets/bottom_nav_bar.dart';
import 'home/lloc_item.dart';

class MisLlocs extends StatefulWidget {
  const MisLlocs({Key? key}) : super(key: key);

  @override
  State<MisLlocs> createState() => _MisLlocsState();
}

class _MisLlocsState extends State<MisLlocs> {
  User? user = Auth().currentUser;
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
                    Navigator.pushNamed(context, Routes.misllocs);
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
                return ListView.builder(
                  itemBuilder: (_, index) => LlocItem(
                      infoLloc: llocs[index],
                      isFirst: index == 0 ? true : false),
                  itemCount: llocs.length,
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
        bottomNavigationBar: const CustomBottomNavBar());
  }

  Stream<List<Lloc>> leerMisLlocS() => FirebaseFirestore.instance
      .collection('llocs')
      .where("correo", isEqualTo: user?.email ?? "Anónimo")
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Lloc.fromJson(doc.data())).toList());
}