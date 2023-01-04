import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../presentation/utils/snack_bar.dart';

class Auth extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  final siguiendo = [];
  final seguidores = [];

  //sign in
  Future<void> signIn(
      BuildContext context, String emailContr, String pswdContr) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: emailContr.trim(), password: pswdContr.trim());
      Utils.showSnackBar("Sesión iniciada como $emailContr");
    } on FirebaseAuthException catch (e) {
      // ignore: avoid_print
      print(e);
      Utils.showSnackBar(e.message);
    }
  }

  //register
  Future register(
      BuildContext context, String emailContr, String pswdContr) async {
    //poner isValid en la función desde donde se llamará
    // final isValid = formKey.currentState!.validate();
    // if (!isValid) return;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));

    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: emailContr.trim(), password: pswdContr.trim());
      await _firebaseAuth.currentUser
          ?.updateDisplayName(emailContr.substring(0, emailContr.indexOf('@')));
      await crearUsuario(currentUser!);
      //await crearUsuario();
    } on FirebaseAuthException catch (e) {
      // ignore: avoid_print
      print(e);
      Utils.showSnackBar(e.message);
    }
  }

  //sign out
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  //aún no está implementado
  Future crearUsuario(User user) async {
    final docLloc =
        FirebaseFirestore.instance.collection("usuarios").doc(user.uid);

    await docLloc.set({
      'uid': user.uid,
      'nombre': user.displayName,
      'correo': user.email,
      'fotoPerfil': user.photoURL ?? "",
      'fechaCreacion': DateFormat("dd/MM/yyyy")
          .format(user.metadata.creationTime ?? DateTime.now())
          .toString(),
      'siguiendo': siguiendo,
      'seguidores': seguidores
    });
  }
}
