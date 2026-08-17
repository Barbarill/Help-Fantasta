import 'package:flutter/material.dart';

void main() {
  runApp(const HelpFantastaApp());
}

class HelpFantastaApp extends StatelessWidget {
  const HelpFantastaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Help Fantasta',
      theme: ThemeData(
        colorSchemeSeed: Colors.green,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help Fantasta')),
      body: const Center(
        child: Text('Progetto avviato 🚀'),
      ),
    );
  }
}