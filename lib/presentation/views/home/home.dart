import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:llocs/presentation/views/home/lloc_item.dart';
import 'package:llocs/domain/const.dart';
import 'package:llocs/presentation/widgets/app_bar_icons.dart';
import 'package:llocs/presentation/widgets/bottom_nav_bar.dart';

import '../../../data/services/auth.dart';
import '../../../domain/models/lloc_model.dart';
import '../../routes/routes.dart';
import '../../../data/services/firestore_llocs.dart';
import '../../widgets/app_logo.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user = Auth().currentUser;

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
                  Navigator.pushNamed(context, Routes.clloc);
                },
              ),
          ],
        ),
        body: StreamBuilder<List<Lloc>>(
            stream: FireStoreLlocs.getLlocS(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text("Algo ha ido mal: ${snapshot.error}");
              } else if (snapshot.hasData) {
                final llocs = snapshot.data!;
                return ListView.builder(
                  itemBuilder: (_, index) => LlocItem(
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
}
