import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/giocatori_provider.dart';
import 'screens/import_screen.dart';

void main() {
  runApp(const HelpFantastaApp());
}

class HelpFantastaApp extends StatelessWidget {
  const HelpFantastaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GiocatoriProvider()..caricaDaStorage(),
      child: MaterialApp(
        title: 'Help Fantasta',
        theme: ThemeData(
          colorSchemeSeed: Colors.green,
          useMaterial3: true,
        ),
        home: const ImportScreen(),
      ),
    );
  }
}