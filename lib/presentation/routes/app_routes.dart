import 'package:flutter/material.dart';
import 'package:llocs/presentation/views/informacion.dart';
import 'package:llocs/presentation/views/misllocs.dart';
import 'package:llocs/presentation/routes/routes.dart';
import 'package:llocs/presentation/views/auth/forgotpswd.dart';
import 'package:llocs/presentation/views/buscarpor.dart';
import 'package:llocs/presentation/views/home/home.dart';
import 'package:llocs/presentation/views/lloc/clloc.dart';
import 'package:llocs/presentation/views/lloc/elloc.dart';
import 'package:llocs/presentation/views/lloc/lloc.dart';
import 'package:llocs/presentation/views/perfil/editarperfil.dart';
import 'package:llocs/presentation/views/perfil/fotoperfil.dart';
import 'package:llocs/presentation/views/perfil/pantallas_loggeo.dart';
import 'package:llocs/presentation/views/perfil/perfil.dart';

import '../views/otrosllocs.dart';

T getArguments<T>(BuildContext context) {
  return ModalRoute.of(context)!.settings.arguments as T;
}

Map<String, Widget Function(BuildContext)> get appRoutes {
  return {
    Routes.home: (_) => const HomeScreen(),
    Routes.lloc: (context) {
      final idLloc = getArguments<String>(context);
      return LlocScreen(idLloc: idLloc);
    },
    Routes.buscarpor: (_) => const BuscarPorScreen(),
    Routes.perfil: (_) => const PerfilScreen(),
    Routes.clloc: (_) => const CLlocScreen(),
    Routes.elloc: (context) {
      final idELloc = getArguments<String>(context);
      return ELlocScreen(idELloc: idELloc);
    },
    Routes.misllocs: (_) => const MisLlocs(),
    Routes.otrosllocs: (context) {
      final correoUser = getArguments<List>(context)[0];
      final nombreUser = getArguments<List>(context)[1];
      return OtrosLlocs(
        correoUser: correoUser,
        nombreUser: nombreUser,
      );
    },
    Routes.informacion: (_) => const InformacionScreen(),
    Routes.editarperfil: (_) => const EditarperfilScreen(),
    Routes.forgotpassword: (_) => const ForgotPasswordScreen(),
    Routes.fotoperfil: (_) => const FotoPerfilScreen(),
    Routes.pantallasloggeo: (_) => const PantallasLoggeo(),
  };
}
