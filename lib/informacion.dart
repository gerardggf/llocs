import 'package:flutter/material.dart';
import 'package:llocz/utils/const.dart';
import 'package:url_launcher/url_launcher.dart';

import 'widgets_globales/bottom_nav_bar.dart';

class InformacionScreen extends StatefulWidget {
  const InformacionScreen({super.key});

  @override
  State<InformacionScreen> createState() => _InformacionScreenState();
}

class _InformacionScreenState extends State<InformacionScreen> {
  final Uri _urlLI = Uri.parse('https://www.linkedin.com/in/gerardgutierrez/');
  final Uri _urlGH = Uri.parse('https://github.com/gerardggf');
  final Uri _urlPP = Uri.parse(
      'https://sites.google.com/view/ppllocs/pol%C3%ADtica-de-privacidad');
  final Uri _urlTC = Uri.parse(
      'https://sites.google.com/view/ppllocs/t%C3%A9rminos-y-condiciones-de-uso');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Información sobre la aplicación"),
        elevation: 0,
      ),
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
                child: Center(
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/img/app_logo_sin_fondo.png",
                        width: 120,
                        height: 120,
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      const Text(
                        "llocs",
                        style: TextStyle(
                            fontSize: 60,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            color: Colors.white),
                      ),
                    ],
                  ),
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
                "Ante cualquier duda o propuesta contacta con uno de los siguientes correos electrónicos:",
                style: TextStyle(fontSize: kFSize1),
              ),
              const SizedBox(height: 5),
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "qallocs@gmail.com\ngerard.ggf@gmail.com",
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
              GestureDetector(
                onTap: () async {
                  if (!await launchUrl(_urlLI)) {
                    throw 'No se pudo abrir el link $_urlLI';
                  }
                },
                child: Row(
                  children: [
                    const SizedBox(
                      width: 15,
                    ),
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
                          "gerardgutierrez",
                          style: TextStyle(
                              fontSize: kFSize1 + 4,
                              fontWeight: FontWeight.bold),
                        ))
                  ],
                ),
              ),
              const SizedBox(height: 15),
              GestureDetector(
                onTap: () async {
                  if (!await launchUrl(_urlGH)) {
                    throw 'No se pudo abrir el link $_urlGH';
                  }
                },
                child: Row(
                  children: [
                    const SizedBox(
                      width: 15,
                    ),
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
                          "gerardggf",
                          style: TextStyle(
                              fontSize: kFSize1 + 4,
                              fontWeight: FontWeight.bold),
                        ))
                  ],
                ),
              ),
              const SizedBox(height: 30),
              const Text("Llocs. Terrassa, Barcelona. 2022."),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                  onTap: () async {
                    if (!await launchUrl(_urlPP)) {
                      throw 'No se pudo abrir el link $_urlPP';
                    }
                  },
                  child: const Text(
                    "Política de privacidad",
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        decoration: TextDecoration.underline),
                  )),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                  onTap: () async {
                    if (!await launchUrl(_urlTC)) {
                      throw 'No se pudo abrir el link $_urlTC';
                    }
                  },
                  child: const Text("Términos y condiciones de uso",
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          decoration: TextDecoration.underline))),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}
