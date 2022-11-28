import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:llocs/backend/autenticacion.dart';
import 'package:llocs/ui_screens/auth/verifyemail.dart';

import '../../widgets_globales/bottom_nav_bar.dart';

class PantallasLoggeo extends StatefulWidget {
  const PantallasLoggeo({Key? key}) : super(key: key);

  @override
  State<PantallasLoggeo> createState() => _PantallasLoggeoState();
}

class _PantallasLoggeoState extends State<PantallasLoggeo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text(
            "Perfil",
            style: TextStyle(fontSize: 25),
          ),
        ),
        body: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text("Algo ha ido mal"),
                );
              } else if (snapshot.hasData) {
                return const VerifyEmailScreen();
              } else {
                return const AuthScreen();
              }
            }),
        bottomNavigationBar: const CustomBottomNavBar());
  }
}
