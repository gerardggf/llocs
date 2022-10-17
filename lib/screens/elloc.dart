import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:llocz/const.dart';
import 'package:llocz/screens/lloc.dart';

import '../models.dart';
import '../utils.dart';
import 'home.dart';

class ELlocScreen extends StatefulWidget {
  const ELlocScreen(this.idELloc, {Key? key}) : super(key: key);

  final String idELloc;

  @override
  State<ELlocScreen> createState() => _ELlocScreenState();
}

class _ELlocScreenState extends State<ELlocScreen> {
  final nNombre = TextEditingController();
  final nCategoria = TextEditingController();
  final nDesc = TextEditingController();
  final nUbicacion = TextEditingController();
  UploadTask? uploadTask;
  final formKey = GlobalKey<FormState>();

  Timer? tempPubl;
  bool puedePublicar = true;

  var nombre = "";
  var categoria = "";
  var desc = "";
  var ubicacion = "";
  var urlDownload = "";

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Lloc?>(
      future: leerLloc(widget.idELloc),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Algo ha ido mal: ${snapshot.error}");
        } else if (snapshot.hasData) {
          final lloc = snapshot.data;

          return lloc == null
              ? const Center(child: Text("No existe el lugar"))
              : buildUpdateFormLloc(context, lloc);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget buildUpdateFormLloc(BuildContext context, Lloc lloc) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Editar lugar",
          ),
          actions: [
            if (puedePublicar != false)
              TextButton.icon(
                onPressed: () {
                  tempPubl = Timer.periodic(const Duration(seconds: 5), (_) {
                    puedePublicar = true;
                  });
                  if (puedePublicar == true) {
                    var isValid = formKey.currentState!.validate();
                    if (!isValid) return;

                    puedePublicar = false;

                    nombre = nNombre.text.trim();
                    if (nombre != "") {
                      nombre = nombre[0].toUpperCase() +
                          nombre.substring(1, nombre.length);
                    }
                    ubicacion = nUbicacion.text.trim();
                    if (ubicacion != "") {
                      ubicacion = ubicacion[0].toUpperCase() +
                          ubicacion.substring(1, ubicacion.length);
                    }
                    categoria = nCategoria.text.trim();
                    if (categoria != "") {
                      categoria = categoria[0].toUpperCase() +
                          categoria.substring(1, categoria.length);
                    }
                    desc = nDesc.text.trim();

                    editarLloc();
                  } else {
                    Utils.showSnackBar(
                        "No puedes volver a publicar hasta pasados 5 segundos");
                  }
                },
                icon: const Icon(
                  Icons.refresh_rounded,
                  color: Colors.white,
                  size: 25,
                ),
                label: const Text(
                  "Actualizar  ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: kFSize1,
                      color: Colors.white),
                ),
              ),
          ],
        ),
        body: SingleChildScrollView(
          child: Form(
              key: formKey,
              child: Container(
                  padding: const EdgeInsets.all(kPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                        controller: nNombre..text = lloc.nombre,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.near_me),
                          labelText: 'Nombre',
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) => value != null && value.isEmpty
                            ? "Rellena el campo"
                            : null,
                      ),
                      TextFormField(
                        controller: nCategoria..text = lloc.categoria,
                        decoration: const InputDecoration(
                            icon: Icon(Icons.category),
                            labelText: 'Categoría',
                            hintText: "Ej: Mirador, pozas, lago, parque..."),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) => value != null && value.isEmpty
                            ? "Rellena el campo"
                            : null,
                      ),
                      TextFormField(
                        controller: nUbicacion..text = lloc.ubicacion,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.place),
                          labelText: 'Ubicación',
                          hintText: "Ej: Ciudad, província, parque natural...",
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) => value != null && value.isEmpty
                            ? "Rellena el campo"
                            : null,
                      ),
                      TextFormField(
                        controller: nDesc..text = lloc.desc,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.description),
                          labelText: 'Descripción',
                          hintText: "Información acerca del lugar",
                        ),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) => value != null && value.isEmpty
                            ? "Rellena el campo"
                            : null,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Image.network(
                        lloc.urlImagen,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      //    width: double.infinity, height: 250),
                      buildProgreso(),
                    ],
                  ))),
        ),
        bottomNavigationBar: bottomB(context));
  }

  Widget buildProgreso() => StreamBuilder<TaskSnapshot>(
        stream: uploadTask?.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final datos = snapshot.data!;
            double progreso = datos.bytesTransferred / datos.totalBytes;

            return SizedBox(
                height: 50,
                child: Stack(fit: StackFit.expand, children: [
                  LinearProgressIndicator(
                      value: progreso,
                      backgroundColor: Colors.grey,
                      color: Colors.green),
                  Center(
                    child: Text(
                      "${(100 * progreso).roundToDouble()}%",
                      style: const TextStyle(color: Colors.white),
                    ),
                  )
                ]));
          } else {
            return const SizedBox(
              height: 50,
            );
          }
        },
      );

  Future editarLloc() async {
    final docLloc =
        FirebaseFirestore.instance.collection("llocs").doc(widget.idELloc);

    final jsonDatos = {
      'nombre': nombre,
      'categoria': categoria,
      'desc': desc,
      //'urlImagen': urlDownload,
      'ubicacion': ubicacion,
    };

    await docLloc.update(jsonDatos);

    // ignore: use_build_context_synchronously
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (Route route) => false);
    // ignore: use_build_context_synchronously
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => LlocScreen(
              idLloc: widget.idELloc,
            )));

    Utils.showSnackBar("Publicación editada");
  }

  Future<Lloc?> leerLloc(idLloc) async {
    final docLloc = FirebaseFirestore.instance.collection("llocs").doc(idLloc);
    final snapshot = await docLloc.get();

    if (snapshot.exists) {
      return Lloc.fromJson(snapshot.data()!);
    }
    return null;
  }
}
