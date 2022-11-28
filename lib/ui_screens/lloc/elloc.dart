import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:llocs/utils/const.dart';
import 'package:llocs/ui_screens/lloc/lloc.dart';
import 'package:llocs/utils/progress_bar.dart';
import 'package:llocs/widgets_globales/app_bar_text_icon.dart';
import 'package:llocs/widgets_globales/bottom_nav_bar.dart';

import '../../models/lloc_model.dart';
import '../../utils/categorias.dart';
import '../../utils/snack_bar.dart';
import '../home/home.dart';

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
    String valoresCategoria = lloc.categoria;

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Editar lugar",
          ),
          actions: [
            if (puedePublicar != false)
              CustomTextIcon(
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
                    desc = nDesc.text.trim();

                    editarLloc();
                  } else {
                    Utils.showSnackBar(
                        "No puedes volver a publicar hasta pasados 5 segundos");
                  }
                },
                iconData: Icons.refresh_rounded,
                text: "Actualizar",
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
                        validator: (value) => value != null && value.isEmpty ||
                                value != null && value.length >= 20
                            ? "El campo debe contener entre 1 y 20 carácteres"
                            : null,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                              labelText: "Categoria",
                              prefixIcon: Icon(Icons.category)),
                          value: valoresCategoria,
                          icon: const Icon(Icons.arrow_downward),
                          onChanged: (String? value) {
                            setState(() {
                              valoresCategoria = value!;
                              categoria = valoresCategoria;
                            });
                          },
                          validator: (value) =>
                              value != null && value.isEmpty ||
                                      value != null && value == "..."
                                  ? "Selecciona una categoría"
                                  : null,
                          items: listaCategorias
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList()),
                      const SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        controller: nUbicacion..text = lloc.ubicacion,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.place),
                          labelText: 'Ubicación',
                          hintText: "Ej: Ciudad, província, parque natural...",
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) => value != null && value.isEmpty ||
                                value != null && value.length >= 20
                            ? "El campo debe contener entre 1 y 20 carácteres"
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
                        validator: (value) => value != null && value.isEmpty ||
                                value != null && value.length >= 250
                            ? "El campo debe contener entre 1 y 250 carácteres"
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
                      ProgressBar(
                        uploadTask: uploadTask,
                      )
                    ],
                  ))),
        ),
        bottomNavigationBar: const CustomBottomNavBar());
  }

  Future editarLloc() async {
    final docLloc =
        FirebaseFirestore.instance.collection("llocs").doc(widget.idELloc);

    final jsonDatos = {
      'nombre': nombre,
      'categoria': categoria,
      'desc': desc,
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
