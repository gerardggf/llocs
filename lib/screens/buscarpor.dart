import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:llocz/const.dart';
import 'package:llocz/screens/home.dart';

import '../models.dart';
import 'lloc.dart';

class BuscarPorScreen extends StatefulWidget {
  const BuscarPorScreen({super.key});

  @override
  State<BuscarPorScreen> createState() => _BuscarPorScreenState();
}

const List<String> list = <String>[
  'Por Ubicación',
  'Por Nombre',
  'Por Usuario',
  'Por Categoria'
];

class _BuscarPorScreenState extends State<BuscarPorScreen> {
  final buscarController = TextEditingController();
  var textoBuscar = "";
  var textoBuscarMayus = "";
  var buscarPor = "ubicacion";
  User? user = FirebaseAuth.instance.currentUser;

  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(8)),
              child: Center(
                  child: TextField(
                      controller: buscarController,
                      decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              buscarController.text = "";
                            },
                          ),
                          hintText: 'Buscar...',
                          border: InputBorder.none),
                      onChanged: ((value) {
                        setState(() {
                          textoBuscar = value;
                          if (textoBuscar.isNotEmpty && buscarPor != "autor") {
                            textoBuscarMayus = textoBuscar[0].toUpperCase() +
                                textoBuscar.substring(1, textoBuscar.length);
                          } else {
                            textoBuscarMayus = textoBuscar;
                          }
                        });
                        leerBuscarLlocS();
                      })))),
          actions: [
            DropdownButton<String>(
              value: dropdownValue,
              elevation: 0,
              dropdownColor: Colors.green,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
              onChanged: (String? value) {
                setState(() {
                  dropdownValue = value!;
                  buscarPor = dropdownValue;
                  switch (buscarPor) {
                    case "Por Ubicación":
                      {
                        buscarPor = "ubicacion";
                      }
                      break;
                    case "Por Nombre":
                      {
                        buscarPor = "nombre";
                      }
                      break;
                    case "Por Usuario":
                      {
                        buscarPor = "autor";
                      }
                      break;
                    case "Por Categoria":
                      {
                        buscarPor = "categoria";
                      }
                      break;
                    default:
                      {}
                      break;
                  }
                });
              },
              items: list.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
        body: StreamBuilder<List<Lloc>>(
            stream: leerBuscarLlocS(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text(
                  "Algo ha ido mal: ${snapshot.error}",
                  style: const TextStyle(color: Colors.white),
                );
              } else if (snapshot.hasData) {
                final llocs = snapshot.data!;
                if (llocs.isEmpty) {
                  return const Center(
                      child: Padding(
                    padding: EdgeInsets.all(kPadding),
                    child: Text(
                      "No hay ninguna coincidencia. Comprueba que estés filtrando por el campo que te interesa.",
                      style: TextStyle(fontSize: kFSize1),
                    ),
                  ));
                }

                return ListView(children: llocs.map(buildLlocs).toList());
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
        bottomNavigationBar: bottomB(context));
  }

  Widget buildLlocs(Lloc lloc) => ListTile(
        leading: Image.network(lloc.urlImagen, width: 50, height: 100),
        title: Text(lloc.nombre),
        isThreeLine: true,
        subtitle: RichText(
          text: TextSpan(
              text: "${lloc.categoria} en ${lloc.ubicacion}\n",
              style: const TextStyle(
                  color: Color.fromARGB(255, 77, 99, 110),
                  fontWeight: FontWeight.w500),
              children: [
                TextSpan(
                    text: lloc.autor,
                    style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey)),
              ]),
        ),
        trailing: Text(
          "${lloc.fechaPubl.substring(0, 10)}\n${lloc.fechaPubl.substring(10, lloc.fechaPubl.length)}",
          textAlign: TextAlign.end,
        ),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => LlocScreen(
              idLloc: lloc.id,
            ),
          ));
        },
      );

  Stream<List<Lloc>> leerBuscarLlocS() {
    return FirebaseFirestore.instance
        .collection('llocs')
        .where(buscarPor, isGreaterThanOrEqualTo: textoBuscarMayus)
        .where(buscarPor, isLessThanOrEqualTo: "$textoBuscarMayus\uf7ff")
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Lloc.fromJson(doc.data())).toList());
  }
}
