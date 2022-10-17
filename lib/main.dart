import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:llocz/const.dart';
import 'package:llocz/utils.dart';

import 'screens/home.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: Utils.messengerKey,
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: kTitulo,
      theme: ThemeData(
        primarySwatch: kColorP,
      ),
      home: const HomeScreen(),
    );
  }
}
