import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:llocs/utils/alert_dialog.dart';
import 'package:llocs/utils/const.dart';
import 'package:llocs/ui_screens/otrosllocs.dart';
import 'package:llocs/ui_screens/perfil/pantallas_loggeo.dart';
import 'package:llocs/widgets_globales/app_bar_icons.dart';
import '../../models/lloc_model.dart';
import '../../utils/snack_bar.dart';
import '../../widgets_globales/bottom_nav_bar.dart';
import 'elloc.dart';
import 'widgets/descripcion.dart';
import 'widgets/encabezado.dart';

class LlocScreen extends StatefulWidget {
  const LlocScreen({Key? key, required this.idLloc}) : super(key: key);

  final String idLloc;

  @override
  State<LlocScreen> createState() => _LlocScreenState();
}

class _LlocScreenState extends State<LlocScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  String fotoPUser = "";

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Lloc?>(
      future: leerLloc(widget.idLloc),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Algo ha ido mal: ${snapshot.error}");
        } else if (snapshot.hasData) {
          final lloc = snapshot.data;

          return lloc == null
              ? const Center(child: Text("No existe el lugar"))
              : buildLloc(context, lloc);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget buildLloc(BuildContext context, Lloc lloc) => Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            lloc.nombre,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          actions: [
            if (user?.email == lloc.correo)
              AppBarIcons(
                  iconData: Icons.edit,
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: ((context) => ELlocScreen(lloc.id))));
                  }),
            if (user?.email == lloc.correo)
              AppBarIcons(
                onPressed: () {
                  showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                            title: const Text('Borrar lugar'),
                            content: const Text(
                                '¿Seguro que deseas eliminar este lugar?'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, 'Cancel'),
                                child: const Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context, 'OK');
                                  FirebaseStorage.instance
                                      .refFromURL(lloc.urlImagen)
                                      .delete();
                                  FirebaseFirestore.instance
                                      .collection("llocs")
                                      .doc(lloc.id)
                                      .delete();
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Sí'),
                              ),
                            ],
                          ));
                },
                iconData: Icons.delete,
              ),
            if (user?.email != lloc.correo && user?.email != null)
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: kColorS,
                  ),
                  child: PopupMenuButton(
                      icon: const Icon(Icons.more_horiz,
                          color: kColorP, size: 20),
                      itemBuilder: (context) {
                        return [
                          const PopupMenuItem<int>(
                            value: 0,
                            child: Text("Ver perfil del usuario"),
                          ),
                          const PopupMenuItem<int>(
                            value: 1,
                            child: Text("Reportar por uso indebido"),
                          ),
                        ];
                      },
                      onSelected: (value) {
                        if (value == 0) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: ((context) => OtrosLlocs(
                                  correoUser: lloc.correo,
                                  nombreUser: lloc.autor))));
                        } else if (value == 1) {
                          showDialog<String>(
                              context: context,
                              builder: (BuildContext context) =>
                                  CustomAlertDialog(
                                    title: 'Reportar publicación',
                                    content:
                                        "¿Quieres reportar esta publicación por inadecuada?",
                                    onPressedYes: () {
                                      Navigator.pop(context, 'OK');
                                      showDialog<String>(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              CustomAlertDialog(
                                                title: "Reportar publicación",
                                                content:
                                                    "¿Estás seguro/a que quieres notificar al administrador de la aplicación por el uso indebido de la misma por parte del usuario ${lloc.autor}?",
                                                onPressedYes: () {
                                                  reportarLloc(
                                                      lloc.correo, lloc.nombre);
                                                  Navigator.pop(context, 'OK');
                                                  Navigator.of(context).pop();
                                                },
                                              ));
                                    },
                                    textPressSYes: "Reportar",
                                  ));
                        }
                      }),
                ),
              ),
          ],
        ),
        body: Column(children: [
          if (user?.email == null)
            SizedBox(
              width: double.infinity,
              height: 50,
              child: GestureDetector(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const PantallasLoggeo())),
                  child: const Padding(
                      padding: EdgeInsets.all(kPadding),
                      child: Text(
                        "Regístrate o inicia sesión aquí para poder compartir tus lugares",
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold),
                      ))),
            ),
          Encabezado(
            autor: lloc.autor,
            categoria: lloc.categoria,
            ubicacion: lloc.ubicacion,
            nombre: lloc.nombre,
            fechaPubl: lloc.fechaPubl,
            correo: lloc.correo,
          ),
          Expanded(
            child: Image.network(
              lloc.urlImagen,
              width: double.infinity,
              height: 400,
              fit: BoxFit.cover,
            ),
          ),
          Descripcion(
            autor: lloc.autor,
            correo: lloc.correo,
            desc: lloc.desc,
          ),
        ]),
        bottomNavigationBar: const CustomBottomNavBar(),
      );

  Future<Lloc?> leerLloc(idLloc) async {
    final docLloc = FirebaseFirestore.instance.collection("llocs").doc(idLloc);
    final snapshot = await docLloc.get();

    if (snapshot.exists) {
      return Lloc.fromJson(snapshot.data()!);
    }
    return null;
  }

  Future reportarLloc(correo, nombre) async {
    final docLloc = FirebaseFirestore.instance.collection("reportes").doc();

    User? user = FirebaseAuth.instance.currentUser;

    final jsonReportarDatos = {
      'id': widget.idLloc,
      'reporta': user?.email,
      'reportado': correo,
      'fechaReport': DateFormat("dd/MM/yyyy HH:mm").format(DateTime.now()),
      'lugar': nombre
    };

    await docLloc.set(jsonReportarDatos);

    Utils.showSnackBar("Lugar reportado");
  }
}
