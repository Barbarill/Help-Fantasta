import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/giocatore.dart';
import '../providers/giocatori_provider.dart';
import '../providers/papabili_provider.dart';
import '../widgets/giocatore_card.dart';
import '../theme/app_theme.dart';

class SfogliaScreen extends StatefulWidget {
  const SfogliaScreen({super.key});

  @override
  State<SfogliaScreen> createState() => _SfogliaScreenState();
}

class _SfogliaScreenState extends State<SfogliaScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  String _query = '';

  static const _ruoli = [
    Ruolo.portiere,
    Ruolo.difensore,
    Ruolo.centrocampista,
    Ruolo.attaccante,
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _ruoli.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sfoglia giocatori'),
        bottom: TabBar(
          controller: _tabController,
          tabs: _ruoli.map((r) => Tab(text: r.nomeCompleto)).toList(),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Cerca per nome o squadra',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) =>
                  setState(() => _query = value.toLowerCase()),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _ruoli.map((ruolo) => _listaRuolo(ruolo)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _listaRuolo(Ruolo ruolo) {
    return Consumer2<GiocatoriProvider, PapabiliProvider>(
      builder: (context, giocatoriProvider, papabiliProvider, _) {
        final giocatori = giocatoriProvider.giocatori
            .where((g) => g.ruolo == ruolo)
            .where((g) =>
                _query.isEmpty ||
                g.nome.toLowerCase().contains(_query) ||
                g.squadra.toLowerCase().contains(_query))
            .toList()
          ..sort((a, b) => (b.fantamedia ?? 0).compareTo(a.fantamedia ?? 0));

        if (giocatori.isEmpty) {
          return const Center(child: Text('Nessun giocatore trovato'));
        }

        return ListView.builder(
          itemCount: giocatori.length,
          itemBuilder: (context, index) {
            final g = giocatori[index];
            final selezionato = papabiliProvider.isPapabile(g.id, ruolo);
            return GiocatoreCard(
              giocatore: g,
              trailing: IconButton(
                icon: Icon(
                  selezionato ? Icons.star : Icons.star_border,
                  color: selezionato ? AppColors.oro : null,
                ),
                onPressed: () {
                  if (selezionato) {
                    papabiliProvider.rimuovi(g);
                  } else {
                    papabiliProvider.aggiungi(g);
                  }
                },
              ),
            );
          },
        );
      },
    );
  }
}