import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:llocs/domain/const.dart';

import '../../domain/models/lloc_model.dart';
import '../widgets/bottom_nav_bar.dart';
import 'home/lloc_item.dart';

class OtrosLlocs extends StatefulWidget {
  const OtrosLlocs(
      {Key? key, required this.correoUser, required this.nombreUser})
      : super(key: key);

  final String correoUser;
  final String nombreUser;

  @override
  State<OtrosLlocs> createState() => _OtrosLlocsState();
}

class _OtrosLlocsState extends State<OtrosLlocs> {
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.nombreUser,
              style: const TextStyle(
                fontSize: 20,
              )),
        ),
        body: StreamBuilder<List<Lloc>>(
            stream: leerOtrosLlocs(),
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

  Stream<List<Lloc>> leerOtrosLlocs() => FirebaseFirestore.instance
      .collection('llocs')
      .where("correo", isEqualTo: widget.correoUser)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Lloc.fromJson(doc.data())).toList());
}
