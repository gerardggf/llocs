import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../informacion.dart';
import '../../utils/alert_dialog.dart';
import '../../utils/const.dart';
import '../editarperfil.dart';
import '../lloc/clloc.dart';
import 'fotoperfil.dart';
import '../../misllocs.dart';
import '../../widgets_globales/item_button.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({Key? key}) : super(key: key);

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    super.initState();
    user.photoURL;
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      user.displayName;
      user.photoURL;
    });

    return SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(kPadding),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(children: [
                    if (user.photoURL != null)
                      GestureDetector(
                          child: CircleAvatar(
                            radius: 40,
                            child: ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: user.photoURL ??
                                    "https://i.picsum.photos/id/9/250/250.jpg?hmac=tqDH5wEWHDN76mBIWEPzg1in6egMl49qZeguSaH9_VI",
                                width: 150,
                                height: 150,
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (_, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                          ),
                          onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const FotoPerfilScreen()))),
                    if (user.photoURL == null)
                      GestureDetector(
                        child: CircleAvatar(
                          radius: 40,
                          child: Text(user.displayName![0].toUpperCase(),
                              style: const TextStyle(
                                  fontSize: 30, color: Colors.white)),
                        ),
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) =>
                                    const FotoPerfilScreen())),
                      ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.displayName!,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: kFSize1),
                        ),
                        Text(
                          user.email!,
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic),
                        ),
                        Text(
                          "Cuenta creada el ${DateFormat("dd/MM/yyyy").format(user.metadata.creationTime ?? DateTime.now())}",
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ]),
                  const SizedBox(
                    width: 20,
                  ),
                  const Divider(),
                  CustomItemButton(
                    iconData: Icons.list,
                    text: "Ver mis publicaciones",
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const MisLlocs(),
                      ),
                    ),
                  ),
                  CustomItemButton(
                    iconData: Icons.person,
                    text: "Editar perfil",
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const EditarperfilScreen(),
                      ),
                    ),
                  ),
                  CustomItemButton(
                    iconData: Icons.post_add,
                    text: "Publicar nuevo lugar",
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const CLlocScreen(),
                      ),
                    ),
                  ),
                  CustomItemButton(
                    iconData: Icons.info_outline_rounded,
                    text: "Información",
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const InformacionScreen(),
                      ),
                    ),
                  ),
                  const Divider(),
                  CustomItemButton(
                      iconData: Icons.exit_to_app,
                      text: "Cerrar sesión",
                      color: Colors.red,
                      onPressed: () => showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => CustomAlertDialog(
                                title: 'Cerrar sesión',
                                content: '¿Seguro que deseas cerrar sesión?',
                                onPressedYes: () {
                                  Navigator.pop(context, 'OK');
                                  FirebaseAuth.instance.signOut();
                                },
                              ))),
                ])));
  }
}
