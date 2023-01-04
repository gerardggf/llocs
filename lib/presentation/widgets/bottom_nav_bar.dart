import 'package:flutter/material.dart';

import '../views/buscarpor.dart';
import '../views/home/home.dart';
import '../views/perfil/pantallas_loggeo.dart';

var indexB = 0;

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_filled),
          label: "Lugares",
        ),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: "Buscar"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil"),
      ],
      onTap: (value) {
        switch (value) {
          case 0:
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const HomeScreen()),
                (Route route) => false);

            break;
          case 1:
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => const BuscarPorScreen()),
                (Route route) => false);
            break;
          case 2:
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => const PantallasLoggeo()),
                (Route route) => false);
            break;
        }
        indexB = value;
      },
      currentIndex: indexB,
    );
  }
}
