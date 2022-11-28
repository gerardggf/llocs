import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:llocz/ui_screens/home/widgets/home_item.dart';
import 'package:llocz/utils/const.dart';
import 'package:llocz/widgets_globales/app_bar_icons.dart';
import 'package:llocz/widgets_globales/bottom_nav_bar.dart';

import '../../models/lloc_model.dart';
import '../../widgets_globales/app_logo.dart';
import '../lloc/clloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kColorP,
          elevation: 0,
          title: const CustomAppLogo(),
          actions: <Widget>[
            if (user?.email != null)
              AppBarIcons(
                iconData: Icons.post_add,
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => const CLlocScreen())));
                },
              ),
          ],
        ),
        body: StreamBuilder<List<Lloc>>(
            stream: leerLlocS(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text("Algo ha ido mal: ${snapshot.error}");
              } else if (snapshot.hasData) {
                final llocs = snapshot.data!;
                return ListView.builder(
                  itemBuilder: (_, index) => HomeItem(
                      infoLloc: llocs[index],
                      isFirst: index == 0 ? true : false),
                  itemCount: llocs.length,
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
        bottomNavigationBar: const CustomBottomNavBar());
  }

  Stream<List<Lloc>> leerLlocS() => FirebaseFirestore.instance
      .collection('llocs')
      .orderBy("fechaPubl", descending: true)
      .limit(50)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Lloc.fromJson(doc.data())).toList());
}
