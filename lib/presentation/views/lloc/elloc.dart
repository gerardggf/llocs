import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:llocs/presentation/routes/routes.dart';
import 'package:llocs/domain/const.dart';
import 'package:llocs/presentation/widgets/progress_bar.dart';
import 'package:llocs/presentation/widgets/app_bar_text_icon.dart';
import 'package:llocs/presentation/widgets/bottom_nav_bar.dart';

import '../../../domain/models/lloc_model.dart';
import '../../../data/services/firestore_llocs.dart';
import '../../../domain/models/categorias.dart';
import '../../utils/snack_bar.dart';
import 'widgets/custom_text_form_field.dart';

class ELlocScreen extends StatefulWidget {
  const ELlocScreen({Key? key, required this.idELloc}) : super(key: key);

  final String idELloc;

  @override
  State<ELlocScreen> createState() => _ELlocScreenState();
}

class _ELlocScreenState extends State<ELlocScreen> {
  final nNombre = TextEditingController();
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
      future: FireStoreLlocs.getLloc(widget.idELloc),
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
    String? validarCampo(value, minCaracteres) {
      if (value != null && value.isEmpty ||
          value != null && value.length >= minCaracteres) {
        return "El campo debe contener entre 1 y $minCaracteres carácteres";
      } else {
        return null;
      }
    }

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

                    if (categoria == "") {
                      categoria = lloc.categoria;
                    }

                    ubicacion = nUbicacion.text.trim();
                    if (ubicacion != "") {
                      ubicacion = ubicacion[0].toUpperCase() +
                          ubicacion.substring(1, ubicacion.length);
                    }

                    desc = nDesc.text.trim();

                    FireStoreLlocs.editarLloc(context, lloc);
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
                      CustomTextFormField(
                        controller: nNombre..text = lloc.nombre,
                        iconData: Icons.near_me,
                        label: "Nombre",
                        maxCaracteres: 20,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                              labelText: "Categoria",
                              icon: Icon(Icons.category)),
                          value: lloc.categoria,
                          icon: const Icon(Icons.arrow_downward),
                          onChanged: (String? value) {
                            setState(() {
                              if (value != null) {
                                categoria = value;
                              }
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
                        height: 10,
                      ),
                      CustomTextFormField(
                        controller: nUbicacion..text = lloc.ubicacion,
                        iconData: Icons.place,
                        label: "Ubicación",
                        hintText: "Ej: Municipio, província, parque natural...",
                        maxCaracteres: 20,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextFormField(
                        controller: nDesc..text = lloc.desc,
                        iconData: Icons.description,
                        label: "Descripción",
                        hintText: "Información acerca del lugar",
                        maxCaracteres: 250,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Image.network(
                        lloc.urlImagen,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      ProgressBar(
                        uploadTask: uploadTask,
                      )
                    ],
                  ))),
        ),
        bottomNavigationBar: const CustomBottomNavBar());
  }
}
