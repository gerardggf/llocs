import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import '../../presentation/utils/snack_bar.dart';
import 'auth.dart';

class FireStoreReportes {
  FireStoreReportes._();

  static Future reportarLloc(idLloc, correo, nombre) async {
    final docLloc = FirebaseFirestore.instance.collection("reportes").doc();

    User? user = Auth().currentUser;

    final jsonReportarDatos = {
      'id': idLloc,
      'reporta': user?.email,
      'reportado': correo,
      'fechaReport': DateFormat("dd/MM/yyyy HH:mm").format(DateTime.now()),
      'lugar': nombre
    };

    await docLloc.set(jsonReportarDatos);

    Utils.showSnackBar("Lugar reportado");
  }
}
