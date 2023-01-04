import 'package:flutter/material.dart';
import 'package:llocs/domain/const.dart';

import '../../domain/models/categorias.dart';
import '../widgets/bottom_nav_bar.dart';

class FiltrarCategScreen extends StatefulWidget {
  const FiltrarCategScreen({super.key});

  @override
  State<FiltrarCategScreen> createState() => _FiltrarCategScreenState();
}

List textosLCateg = listaCategorias;

//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//ESTA SCREEN  NO FUNCIONA BIEN AL DESELECCIONAR UN ITEM DE TODOS QUE NO SEA EL PRIMERO DEL ARRAY

class _FiltrarCategScreenState extends State<FiltrarCategScreen> {
  var isSelectLCateg = List.filled(listaCategorias.length, true);
  List listaFiltrarCateg = listaCategorias;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Filtrar por categoría"),
        actions: [
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(
              Icons.filter_alt,
              color: Colors.white,
              size: 25,
            ),
            label: const Text(
              "Filtrar  ",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: kFSize1,
                  color: Colors.white),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: listaFiltrarCateg.length,
        itemBuilder: (BuildContext context, int index) {
          return CheckboxListTile(
              title: Text(listaFiltrarCateg[index]),
              value: isSelectLCateg[index],
              onChanged: (value) {
                setState(() {
                  isSelectLCateg[index] = !isSelectLCateg[index];
                });
                if (value == true && listaFiltrarCateg[index] != "...") {
                  textosLCateg.add(listaFiltrarCateg[index]);
                } else if (value == false &&
                    listaFiltrarCateg[index] != "...") {
                  try {
                    textosLCateg.removeWhere(
                        (item) => item == listaFiltrarCateg[index]);
                  } catch (e) {
                    // ignore: avoid_print
                    print(e);
                  }
                }

                if (listaFiltrarCateg[index] == "..." && value == true) {
                  isSelectLCateg = List.filled(listaCategorias.length, true);
                  textosLCateg.addAll(listaFiltrarCateg);
                  textosLCateg.removeWhere((item) => item == "...");
                } else if (listaFiltrarCateg[index] == "..." &&
                    value == false) {
                  isSelectLCateg = List.filled(listaCategorias.length, false);
                  textosLCateg = [];
                }
                if (textosLCateg.length != listaFiltrarCateg.length + 1) {
                  isSelectLCateg[0] = false;
                  textosLCateg.removeWhere((item) => item == "...");
                }
                setState(() {
                  textosLCateg;
                });
                // ignore: avoid_print
                print(textosLCateg);
              });
        },
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}
