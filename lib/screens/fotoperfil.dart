import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:llocz/const.dart';
import 'package:llocz/screens/home.dart';
import 'package:llocz/screens/perfil.dart';
import 'package:path_provider/path_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as p;

import '../utils.dart';

class FotoPerfilScreen extends StatefulWidget {
  const FotoPerfilScreen({super.key});

  @override
  State<FotoPerfilScreen> createState() => _FotoPerfilScreenState();
}

class _FotoPerfilScreenState extends State<FotoPerfilScreen> {
  PlatformFile? pickedFile;
  UploadTask? uploadTask;

  User? user = FirebaseAuth.instance.currentUser;

  bool puedePublicar = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Subir/Cambiar foto de perfil"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(kPadding),
        child: Column(children: [
          if (pickedFile != null)
            Image.file(File(pickedFile!.path!),
                width: double.infinity, height: 400),
          if (puedePublicar == true)
            TextButton.icon(
                style: TextButton.styleFrom(
                    minimumSize: const Size.fromHeight(50)),
                icon: const Icon(Icons.add_a_photo, color: Colors.black),
                onPressed: selectFile,
                label: const Text(
                  "Seleccionar imagen",
                  style: TextStyle(fontSize: kFSize1, color: Colors.black),
                )),
          const SizedBox(
            height: kPadding,
          ),
          if (puedePublicar == true)
            ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(35),
                    backgroundColor: Colors.red),
                icon: const Icon(Icons.delete, size: 20),
                label: const Text(
                  "Eliminar imagen del perfil",
                  style: TextStyle(fontSize: 18),
                ),
                onPressed: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          title: const Text('Eliminar imagen del perfil'),
                          content: const Text(
                              '¿Seguro que quieres eliminar tu imagen del perfil?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Cancel'),
                              child: const Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () {
                                user?.updatePhotoURL(null);
                                setState(() {
                                  user?.photoURL;
                                });
                                Utils.showSnackBar(
                                    "Imagen eliminada. La imagen de perfil puede tardar un rato en actualizarse.");
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const PerfilScreen()),
                                    (Route route) => false);
                              },
                              child: const Text('Sí'),
                            ),
                            Container(
                              height: 100,
                            )
                          ],
                        ))),
          const SizedBox(
            height: kPadding,
          ),
          if (puedePublicar == true)
            TextButton.icon(
                style: TextButton.styleFrom(
                  minimumSize: const Size.fromHeight(45),
                ),
                icon: const Icon(Icons.save, size: 25),
                label: const Text(
                  "Guardar",
                  style: TextStyle(fontSize: 18),
                ),
                onPressed: () {
                  if (pickedFile != null) {
                    puedePublicar = false;
                    subirFile();
                  } else {
                    Utils.showSnackBar("Selecciona una imagen");
                  }
                })
        ]),
      ),
      bottomNavigationBar: bottomB(context),
    );
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

    final urlDownloadPhoto = await snapshot.ref.getDownloadURL();
    user?.updatePhotoURL(urlDownloadPhoto);
    // ignore: use_build_context_synchronously
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const PerfilScreen()),
        (Route route) => false);

    Utils.showSnackBar(
        "Foto de perfil guardada correctamente. La imagen de perfil puede tardar un rato en actualizarse.");
  }
}
