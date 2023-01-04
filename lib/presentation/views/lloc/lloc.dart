import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:llocs/presentation/routes/routes.dart';
import 'package:llocs/presentation/widgets/alert_dialog.dart';
import 'package:llocs/domain/const.dart';
import 'package:llocs/presentation/widgets/app_bar_icons.dart';
import '../../../data/services/auth.dart';
import '../../../domain/models/lloc_model.dart';
import '../../../data/services/firestore_llocs.dart';
import '../../../data/services/firestore_reportes.dart';
import '../../utils/snack_bar.dart';
import '../../widgets/bottom_nav_bar.dart';
import 'widgets/descripcion.dart';
import 'widgets/encabezado.dart';

class LlocScreen extends StatefulWidget {
  const LlocScreen({Key? key, required this.idLloc}) : super(key: key);

  final String idLloc;

  @override
  State<LlocScreen> createState() => _LlocScreenState();
}

class _LlocScreenState extends State<LlocScreen> {
  User? user = Auth().currentUser;
  String fotoPUser = "";

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Lloc?>(
      future: FireStoreLlocs.getLloc(widget.idLloc),
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
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios_new_outlined,
            ),
            color: kColorS,
          ),
          elevation: 0,
          title: FittedBox(
            child: Text(
              lloc.nombre,
              style: const TextStyle(color: kColorS),
            ),
          ),
          actions: [
            if (user?.email == lloc.correo)
              AppBarIcons(
                iconData: Icons.edit,
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    Routes.elloc,
                    arguments: lloc.id,
                  );
                },
              ),
            if (user?.email == lloc.correo)
              AppBarIcons(
                onPressed: () {
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => CustomAlertDialog(
                      title: "Eliminar lugar",
                      content: "¿Estás seguro que deseas eliminar este lugar?",
                      onPressedYes: () {
                        FireStoreLlocs.eliminarLloc(context, lloc);
                        Navigator.of(context).pop();
                      },
                    ),
                  );
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
                    icon:
                        const Icon(Icons.more_horiz, color: kColorP, size: 20),
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
                        Navigator.pushNamed(context, Routes.otrosllocs,
                            arguments: [lloc.correo, lloc.autor]);
                      } else if (value == 1) {
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => CustomAlertDialog(
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
                                    FireStoreReportes.reportarLloc(
                                        widget.idLloc,
                                        lloc.correo,
                                        lloc.nombre);
                                    Navigator.pop(context, 'OK');
                                    Navigator.of(context).pop();
                                  },
                                ),
                              );
                            },
                            textPressSYes: "Reportar",
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
          ],
        ),
        body: Column(children: [
          if (user?.email == null)
            Container(
              width: double.infinity,
              color: kColorP,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Container(
                  decoration: const BoxDecoration(color: kColorP),
                  child: GestureDetector(
                    onTap: () => Navigator.pushNamed(
                      context,
                      Routes.pantallasloggeo,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(kPadding),
                      child: Container(
                        padding: const EdgeInsets.all(kPadding),
                        decoration: BoxDecoration(
                            color: kColorS,
                            borderRadius: BorderRadius.circular(20)),
                        child: const Text(
                          "Regístrate o inicia sesión para poder compartir tus lugares",
                          style: TextStyle(
                              fontSize: 15,
                              color: kColorP,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
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
            child: CachedNetworkImage(
              imageUrl: lloc.urlImagen,
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
}
