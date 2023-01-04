import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:llocs/presentation/routes/routes.dart';
import 'package:llocs/data/services/auth.dart';
import 'package:llocs/presentation/views/home/home.dart';
import 'package:llocs/presentation/utils/app_theme.dart';
import 'package:llocs/domain/const.dart';
import 'package:llocs/presentation/utils/snack_bar.dart';
import 'package:provider/provider.dart';

import 'presentation/routes/app_routes.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (_) => const MyApp(),
    ),
  );
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Auth>(create: (_) => Auth()),
      ],
      child: MaterialApp(
        useInheritedMediaQuery: true,
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        scaffoldMessengerKey: Utils.messengerKey,
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: kTitulo,
        theme: getThemeData(context),
        home: const HomeScreen(),
        initialRoute: Routes.initialRoute,
        routes: appRoutes,
      ),
    );
  }
}
