import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

class MainScaffold extends StatelessWidget {
  const MainScaffold({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Symbols.group, fill: 0),
            activeIcon: Icon(Symbols.group, fill: 1),
            label: 'Annuaire',
          ),
          BottomNavigationBarItem(
            icon: Icon(Symbols.location_on, fill: 0),
            activeIcon: Icon(Symbols.location_on, fill: 1),
            label: 'Carte',
          ),
          BottomNavigationBarItem(
            icon: Icon(Symbols.person, fill: 0),
            activeIcon: Icon(Symbols.person, fill: 1),
            label: 'Profil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Symbols.settings, fill: 0),
            activeIcon: Icon(Symbols.settings, fill: 1),
            label: 'Réglages',
          ),
        ],
      ),
    );
  }
}