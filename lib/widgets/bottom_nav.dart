import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key, required this.current});

  final String current;

  int get _currentIndex {
    switch (current) {
      case 'home':
        return 0;
      case 'requests':
        return 1;
      case 'trips':
        return 2;
      case 'profile':
        return 3;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        switch (index) {
          case 0:
            context.go('/home');
            return;
          case 1:
            context.go('/requests');
            return;
          case 2:
            context.go('/trips');
            return;
          case 3:
            context.go('/profile');
            return;
          default:
            context.go('/home');
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Accueil',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.message),
          label: 'Demandes',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.directions_car),
          label: 'Trajets',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Profil',
        ),
      ],
    );
  }
}
