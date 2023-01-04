import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:llocs/data/services/auth.dart';
import 'package:llocs/presentation/routes/routes.dart';
import 'package:provider/provider.dart';

import '../../widgets/alert_dialog.dart';
import '../../../domain/const.dart';
import '../../widgets/item_button.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({Key? key}) : super(key: key);

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Auth().currentUser!;
    return Padding(
        padding: const EdgeInsets.all(kPadding),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
            Widget>[
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
                      errorWidget: (_, url, error) => const Icon(Icons.error),
                    ),
                  ),
                ),
                onTap: () =>
                    Navigator.pushReplacementNamed(context, Routes.fotoperfil),
              ),
            if (user.photoURL == null)
              GestureDetector(
                child: CircleAvatar(
                  radius: 40,
                  child: Text(user.displayName![0].toUpperCase(),
                      style:
                          const TextStyle(fontSize: 30, color: Colors.white)),
                ),
                onTap: () =>
                    Navigator.pushReplacementNamed(context, Routes.fotoperfil),
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
            onPressed: () => Navigator.pushNamed(context, Routes.misllocs),
          ),
          CustomItemButton(
            iconData: Icons.person,
            text: "Editar perfil",
            onPressed: () =>
                Navigator.pushReplacementNamed(context, Routes.editarperfil),
          ),
          CustomItemButton(
            iconData: Icons.post_add,
            text: "Publicar nuevo lugar",
            onPressed: () => Navigator.pushNamed(context, Routes.clloc),
          ),
          CustomItemButton(
            iconData: Icons.info_outline_rounded,
            text: "Información",
            onPressed: () => Navigator.pushNamed(context, Routes.informacion),
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
                          Auth().signOut();
                        },
                      ))),
        ]));
  }
}
