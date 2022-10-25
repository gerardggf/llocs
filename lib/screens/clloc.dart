import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:llocz/const.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as p;

import '../utils.dart';
import 'home.dart';

class CLlocScreen extends StatefulWidget {
  const CLlocScreen({Key? key}) : super(key: key);

  @override
  State<CLlocScreen> createState() => _CLlocScreenState();
}

const List<String> listaCategorias = <String>[
  "...",
  "Bosque",
  "Calle",
  "Edificio",
  "Evento",
  "Festival",
  "Fuente",
  "Minas",
  "Mirador",
  "Montaña",
  "Monumento",
  "Museo",
  "Lago",
  "Parque",
  "Playa",
  "Plaza",
  "Poza",
  "Pueblo",
  "Sala de conciertos",
  "Sierra",
  "Valle",
  "Vía escalada",
  "Vía ferrata",
  "Otros"
];

class _CLlocScreenState extends State<CLlocScreen> {
  final nNombre = TextEditingController();
  final nDesc = TextEditingController();
  final nUbicacion = TextEditingController();
  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  final formKey = GlobalKey<FormState>();

  String valoresCategoria = listaCategorias.first;
  Timer? tempPubl;
  bool puedePublicar = true;

  var nombre = "";
  var categoria = "";
  var desc = "";
  var ubicacion = "";
  var urlDownload = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Nuevo lugar",
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
                    setState(() {
                      pickedFile;
                    });
                    if (pickedFile == null) {
                      isValid = false;
                      Utils.showSnackBar("No has seleccionado ninguna imagen");
                    }
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

                    subirFile();
                  } else {
                    Utils.showSnackBar(
                        "No puedes volver a publicar hasta pasados 5 segundos");
                  }
                },
                icon: const Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                  size: 15,
                ),
                label: const Text(
                  "Publicar  ",
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      if (puedePublicar == false) buildProgreso(),
                      TextFormField(
                        controller: nNombre,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.near_me),
                          labelText: 'Nombre',
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) => value != null && value.isEmpty
                            ? "Rellena el campo"
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
                        controller: nUbicacion,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.place),
                          labelText: 'Ubicación',
                          hintText:
                              "Ej: Municipio, província, parque natural...",
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) => value != null && value.isEmpty
                            ? "Rellena el campo"
                            : null,
                      ),
                      TextFormField(
                        controller: nDesc,
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
                      if (pickedFile != null)
                        Image.file(File(pickedFile!.path!),
                            width: double.infinity, height: 250),
                      TextButton.icon(
                          style: TextButton.styleFrom(
                              minimumSize: const Size.fromHeight(50)),
                          icon: const Icon(Icons.add_a_photo,
                              color: Colors.black),
                          onPressed: selectFile,
                          label: const Text(
                            "Seleccionar imagen",
                            style: TextStyle(
                                fontSize: kFSize1, color: Colors.black),
                          )),
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

  Future crearLloc() async {
    final docLloc = FirebaseFirestore.instance.collection("llocs").doc();

    User? user = FirebaseAuth.instance.currentUser;

    final jsonDatos = {
      'id': docLloc.id,
      'nombre': nombre,
      'categoria': categoria,
      'desc': desc,
      'fechaPubl': DateFormat("dd/MM/yyyy HH:mm").format(DateTime.now()),
      'autor': user?.displayName ?? "Anónimo",
      'correo': user?.email ?? "Sin correo asignado",
      'urlImagen': urlDownload,
      'ubicacion': ubicacion,
      'likes': 0
    };

    await docLloc.set(jsonDatos);

    // ignore: use_build_context_synchronously
    Navigator.pop(context);

    Utils.showSnackBar("Nuevo lugar publicado");
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      pickedFile = result.files.first;
    });
  }

  Future compressImage(String path, int quality) async {
    final newPath = p.join((await getTemporaryDirectory()).path,
        '${DateTime.now()}.${p.extension(path)}');

    final result = await FlutterImageCompress.compressAndGetFile(path, newPath,
        quality: quality);

    return result;
  }

  Future subirFile() async {
    final path = 'llocs/${pickedFile!.name}';
    var file2 = await compressImage(pickedFile!.path!, 30);

    final ref = FirebaseStorage.instance.ref().child(path);
    setState(() {
      uploadTask = ref.putFile(file2);
    });

    final snapshot = await uploadTask!.whenComplete(() {});

    urlDownload = await snapshot.ref.getDownloadURL();

    crearLloc();
  }
}
