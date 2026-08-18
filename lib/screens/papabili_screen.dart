import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/giocatore.dart';
import '../providers/giocatori_provider.dart';
import '../providers/papabili_provider.dart';
import '../widgets/giocatore_card.dart';

class PapabiliScreen extends StatefulWidget {
  const PapabiliScreen({super.key});

  @override
  State<PapabiliScreen> createState() => _PapabiliScreenState();
}

class _PapabiliScreenState extends State<PapabiliScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

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
        title: const Text('I miei papabili'),
        bottom: TabBar(
          controller: _tabController,
          tabs: _ruoli.map((r) => Tab(text: r.nomeCompleto)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _ruoli.map((ruolo) => _listaRuolo(ruolo)).toList(),
      ),
    );
  }

  Widget _listaRuolo(Ruolo ruolo) {
    return Consumer2<GiocatoriProvider, PapabiliProvider>(
      builder: (context, giocatoriProvider, papabiliProvider, _) {
        final mappaGiocatori = {
          for (final g in giocatoriProvider.giocatori) g.id: g,
        };
        final ids = papabiliProvider.perRuolo(ruolo);
        final giocatori = ids
            .map((id) => mappaGiocatori[id])
            .whereType<Giocatore>()
            .toList();

        if (giocatori.isEmpty) {
          return const Center(
            child: Text('Nessun papabile ancora — aggiungili da "Sfoglia"'),
          );
        }

        return ReorderableListView.builder(
          itemCount: giocatori.length,
          onReorder: (oldIndex, newIndex) {
            papabiliProvider.riordina(ruolo, oldIndex, newIndex);
          },
          itemBuilder: (context, index) {
            final g = giocatori[index];
                        return GiocatoreCard(
              key: ValueKey(g.id),
              giocatore: g,
              sottotitoloExtra: '#${index + 1} • ${g.squadra}'
                  '${g.fantamedia != null ? " • FM ${g.fantamedia!.toStringAsFixed(2)}" : ""}',
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => papabiliProvider.rimuovi(g),
                  ),
                  const Icon(Icons.drag_handle, color: Colors.grey),
                ],
              ),
            );
          },
        );
      },
    );
  }
}