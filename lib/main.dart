import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/giocatori_provider.dart';
import 'providers/papabili_provider.dart';
import 'providers/asta_provider.dart';
import 'screens/import_screen.dart';
import 'screens/sfoglia_screen.dart';
import 'screens/papabili_screen.dart';
import 'screens/asta_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const HelpFantastaApp());
}

class HelpFantastaApp extends StatelessWidget {
  const HelpFantastaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => GiocatoriProvider()..caricaDaStorage(),
        ),
        ChangeNotifierProvider(
          create: (_) => PapabiliProvider()..carica(),
        ),
        ChangeNotifierProvider(
          create: (_) => AstaProvider()..carica(),
        ),
      ],
      child: MaterialApp(
        title: 'Help Fantasta',
        theme: AppTheme.tema,
        home: const HomeNavigation(),
      ),
    );
  }
}

class HomeNavigation extends StatefulWidget {
  const HomeNavigation({super.key});

  @override
  State<HomeNavigation> createState() => _HomeNavigationState();
}

class _HomeNavigationState extends State<HomeNavigation> {
  int _index = 0;

  final _screens = const [
    ImportScreen(),
    SfogliaScreen(),
    PapabiliScreen(),
    AstaScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.upload_file), label: 'Import'),
          NavigationDestination(icon: Icon(Icons.search), label: 'Sfoglia'),
          NavigationDestination(icon: Icon(Icons.star), label: 'Papabili'),
          NavigationDestination(icon: Icon(Icons.gavel), label: 'Asta'),
        ],
      ),
    );
  }
}