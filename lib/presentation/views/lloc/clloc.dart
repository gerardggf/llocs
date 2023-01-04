import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:llocs/presentation/views/lloc/widgets/custom_text_form_field.dart';
import 'package:llocs/domain/const.dart';
import 'package:intl/intl.dart';
import 'package:llocs/presentation/widgets/progress_bar.dart';
import 'package:llocs/presentation/widgets/app_bar_text_icon.dart';
import 'package:llocs/presentation/widgets/item_button.dart';
import 'package:path_provider/path_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as p;

import '../../../data/services/auth.dart';
import '../../../domain/models/categorias.dart';
import '../../utils/snack_bar.dart';
import '../../widgets/bottom_nav_bar.dart';

class CLlocScreen extends StatefulWidget {
  const CLlocScreen({Key? key}) : super(key: key);

  @override
  State<CLlocScreen> createState() => _CLlocScreenState();
}

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
              CustomTextIcon(
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
                iconData: Icons.send_rounded,
                text: "Publicar",
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
                      if (puedePublicar == false)
                        ProgressBar(
                          uploadTask: uploadTask,
                        ),
                      CustomTextFormField(
                        controller: nNombre,
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
                        height: 10,
                      ),
                      CustomTextFormField(
                        controller: nUbicacion,
                        iconData: Icons.place,
                        label: "Ubicación",
                        hintText: "Ej: Municipio, província, parque natural...",
                        maxCaracteres: 20,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextFormField(
                        controller: nDesc,
                        iconData: Icons.description,
                        label: "Descripción",
                        hintText: "Información acerca del lugar",
                        maxCaracteres: 250,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      if (pickedFile != null)
                        Image.file(File(pickedFile!.path!),
                            width: double.infinity, height: 250),
                      CustomItemButton(
                          iconData: Icons.add_a_photo,
                          text: "Seleccionar Imagen",
                          onPressed: selectFile),
                    ],
                  ))),
        ),
        bottomNavigationBar: const CustomBottomNavBar());
  }

  Future crearLloc() async {
    final docLloc = FirebaseFirestore.instance.collection("llocs").doc();

    User? user = Auth().currentUser;

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
