import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../../domain/models/lloc_model.dart';
import '../../presentation/routes/routes.dart';
import '../../presentation/utils/snack_bar.dart';

class FireStoreLlocs {
  FireStoreLlocs._();

  //leer todos los llocs
  static Stream<List<Lloc>> getLlocS() => FirebaseFirestore.instance
      .collection('llocs')
      .orderBy("fechaPubl", descending: true)
      .limit(50)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Lloc.fromJson(doc.data())).toList());

  //leer lloc
  static Future<Lloc?> getLloc(idLloc) async {
    final docLloc = FirebaseFirestore.instance.collection("llocs").doc(idLloc);
    final snapshot = await docLloc.get();

    if (snapshot.exists) {
      return Lloc.fromJson(snapshot.data()!);
    }
    return null;
  }

  //editar lloc
  static Future editarLloc(context, Lloc lloc) async {
    final docLloc = FirebaseFirestore.instance.collection("llocs").doc(lloc.id);

    final jsonDatos = {
      'nombre': lloc.nombre,
      'categoria': lloc.categoria,
      'desc': lloc.desc,
      'ubicacion': lloc.ubicacion,
    };

    await docLloc.update(jsonDatos);
    // ignore: use_build_context_synchronously
    Navigator.pushNamedAndRemoveUntil(
        context, Routes.home, (Route route) => false);
    // ignore: use_build_context_synchronously
    Navigator.pushNamed(context, Routes.lloc, arguments: lloc.id);

    Utils.showSnackBar("Publicación editada");
  }

  static Future eliminarLloc(context, Lloc lloc) async {
    Navigator.pop(context, 'OK');
    await FirebaseStorage.instance.refFromURL(lloc.urlImagen).delete();
    await FirebaseFirestore.instance.collection("llocs").doc(lloc.id).delete();
    Utils.showSnackBar("Publicación eliminada correctamente");
  }
}
