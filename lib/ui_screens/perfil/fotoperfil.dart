import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:llocs/utils/alert_dialog.dart';
import 'package:llocs/utils/const.dart';
import 'package:llocs/ui_screens/perfil/pantallas_loggeo.dart';
import 'package:path_provider/path_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as p;

import '../../utils/snack_bar.dart';
import '../../widgets_globales/bottom_nav_bar.dart';

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
          if (pickedFile != null)
            Image.file(File(pickedFile!.path!),
                width: double.infinity, height: 400),
          const SizedBox(
            height: kPadding,
          ),
          if (puedePublicar == true && pickedFile != null)
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
                }),
          const Divider(),
          const SizedBox(
            height: kPadding,
          ),
          if (puedePublicar == true)
            TextButton.icon(
                style: TextButton.styleFrom(
                  minimumSize: const Size.fromHeight(35),
                ),
                icon: const Icon(
                  Icons.delete,
                  size: 20,
                  color: Colors.red,
                ),
                label: const Text(
                  "Eliminar imagen del perfil",
                  style: TextStyle(fontSize: 18, color: Colors.red),
                ),
                onPressed: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => CustomAlertDialog(
                          title: 'Eliminar actual imagen del perfil',
                          content:
                              '¿Seguro que quieres eliminar tu imagen del perfil?',
                          onPressedYes: () {
                            try {
                              FirebaseStorage.instance
                                  .refFromURL(user!.photoURL!)
                                  .delete();
                              user?.updatePhotoURL(null);
                              setState(() {
                                user?.photoURL;
                              });
                              Utils.showSnackBar(
                                  "Imagen eliminada. La imagen de perfil puede tardar un rato en actualizarse.");
                              Navigator.pop(context, 'OK');
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const PantallasLoggeo()),
                                  (Route route) => false);
                            } catch (e) {
                              Utils.showSnackBar(
                                  "Actualmente no tienes ninguna imagen de perfil configurada");
                              Navigator.pop(context, 'OK');
                            }
                          },
                        ))),
        ]),
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
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
        MaterialPageRoute(builder: (context) => const PantallasLoggeo()),
        (Route route) => false);

    Utils.showSnackBar(
        "Foto de perfil guardada correctamente. La imagen de perfil puede tardar un rato en actualizarse.");
  }
}
