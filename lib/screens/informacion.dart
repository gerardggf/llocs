import 'package:flutter/material.dart';
import 'package:llocz/const.dart';
import 'package:llocz/screens/home.dart';

class InformacionScreen extends StatefulWidget {
  const InformacionScreen({super.key});

  @override
  State<InformacionScreen> createState() => _InformacionScreenState();
}

class _InformacionScreenState extends State<InformacionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Información sobre la aplicación")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(kPadding),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: kColorP,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.green,
                      spreadRadius: 150,
                      blurRadius: 120,
                    ),
                  ],
                ),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Image.asset("assets/img/logo_app_grande.png")
                    // Text(
                    //   "llocs",
                    //   style: TextStyle(
                    //       fontSize: kFSize1 + 15, fontWeight: FontWeight.bold),
                    // ),
                    ),
              ),
              const SizedBox(height: 25),
              RichText(
                  text: const TextSpan(
                      text: "La aplicación de ",
                      style: TextStyle(fontSize: kFSize1, color: Colors.black),
                      children: [
                    TextSpan(
                      text: "llocs",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    ),
                    TextSpan(
                      text:
                          " es una red social orientada a la publicación de lugares de interés de distintos ámbitos, para poder compartir con toda la red sitios o eventos que puedan ser de interés.",
                    ),
                  ])),
              const SizedBox(height: 40),
              const Text(
                "Ante cualquier duda o propuesta contacta con el siguiente correo electrónico:",
                style: TextStyle(fontSize: kFSize1),
              ),
              const SizedBox(height: 5),
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "qallocs@gmail.com",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: kFSize1),
                ),
              ),
              const SizedBox(height: 25),
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Mis redes sociales:",
                  style: TextStyle(fontSize: kFSize1),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Flexible(
                      flex: 1,
                      child: Image.asset(
                        "assets/img/linkedin.png",
                        height: 30,
                        width: 30,
                      )),
                  const SizedBox(
                    width: 10,
                  ),
                  const Flexible(
                      flex: 4,
                      child: Text(
                        "LinkedIn:  gerardgutierrez",
                        style: TextStyle(
                            fontSize: kFSize1, fontWeight: FontWeight.bold),
                      ))
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Flexible(
                      flex: 1,
                      child: Image.asset(
                        "assets/img/github.png",
                        height: 30,
                        width: 30,
                      )),
                  const SizedBox(
                    width: 10,
                  ),
                  const Flexible(
                      flex: 4,
                      child: Text(
                        "GitHub:  gerardggf",
                        style: TextStyle(
                            fontSize: kFSize1, fontWeight: FontWeight.bold),
                      ))
                ],
              ),
              const SizedBox(height: 40),
              const Text("Terrassa, Barcelona. 2022.")
            ],
          ),
        ),
      ),
      bottomNavigationBar: bottomB(context),
    );
  }
}
