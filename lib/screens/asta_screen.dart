import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/asta.dart';
import '../models/giocatore.dart';
import '../providers/asta_provider.dart';
import '../providers/giocatori_provider.dart';
import '../widgets/ricerca_giocatore_dialog.dart';

class AstaScreen extends StatelessWidget {
  const AstaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AstaProvider>(
      builder: (context, astaProvider, _) {
        if (astaProvider.caricamento) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!astaProvider.astaConfigurata) {
          return const _SetupAsta();
        }
        return const _RosaAsta();
      },
    );
  }
}

class _SetupAsta extends StatefulWidget {
  const _SetupAsta();

  @override
  State<_SetupAsta> createState() => _SetupAstaState();
}

class _SetupAstaState extends State<_SetupAsta> {
  final _budgetController = TextEditingController(text: '500');
  final _portieriController = TextEditingController(text: '3');
  final _difensoriController = TextEditingController(text: '8');
  final _centrocampistiController = TextEditingController(text: '8');
  final _attaccantiController = TextEditingController(text: '6');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configura asta')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: _budgetController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Budget totale (fantacrediti)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Numero giocatori per reparto',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _campoSlot('Portieri', _portieriController),
            _campoSlot('Difensori', _difensoriController),
            _campoSlot('Centrocampisti', _centrocampistiController),
            _campoSlot('Attaccanti', _attaccantiController),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => _avvia(context),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text('Inizia asta'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _campoSlot(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  void _avvia(BuildContext context) {
    final budget = double.tryParse(_budgetController.text);
    final portieri = int.tryParse(_portieriController.text);
    final difensori = int.tryParse(_difensoriController.text);
    final centrocampisti = int.tryParse(_centrocampistiController.text);
    final attaccanti = int.tryParse(_attaccantiController.text);

    if ([budget, portieri, difensori, centrocampisti, attaccanti]
        .contains(null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Compila tutti i campi correttamente')),
      );
      return;
    }

    context.read<AstaProvider>().impostaConfig(AstaConfig(
          budgetTotale: budget!,
          slotPortieri: portieri!,
          slotDifensori: difensori!,
          slotCentrocampisti: centrocampisti!,
          slotAttaccanti: attaccanti!,
        ));
  }
}

class _RosaAsta extends StatelessWidget {
  const _RosaAsta();

  static const _ruoli = [
    Ruolo.portiere,
    Ruolo.difensore,
    Ruolo.centrocampista,
    Ruolo.attaccante,
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer2<AstaProvider, GiocatoriProvider>(
      builder: (context, astaProvider, giocatoriProvider, _) {
        final mappaGiocatori = {
          for (final g in giocatoriProvider.giocatori) g.id: g,
        };

        return Scaffold(
          appBar: AppBar(
            title: const Text('La mia rosa'),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                tooltip: 'Reimposta asta',
                onPressed: () => _confermaReset(context),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => mostraRicercaGiocatore(context),
            icon: const Icon(Icons.add),
            label: const Text('Assegna giocatore'),
          ),
          body: Column(
            children: [
              _HeaderBudget(astaProvider: astaProvider),
              Expanded(
                child: ListView(
                  children: _ruoli.map((ruolo) {
                    final acquistiRuolo = astaProvider.acquisti
                        .where((a) => a.ruolo == ruolo)
                        .toList();
                    return ExpansionTile(
                      title: Text(
                        '${ruolo.nomeCompleto} '
                        '(${astaProvider.slotOccupati(ruolo)}/${astaProvider.config!.slotPerRuolo(ruolo)}'
                        ' — ${astaProvider.spesoPerRuolo(ruolo).toStringAsFixed(0)} cr)',
                      ),
                      initiallyExpanded: true,
                      children: acquistiRuolo.map((a) {
                        final g = mappaGiocatori[a.giocatoreId];
                        return ListTile(
                          title: Text(g?.nome ?? 'Giocatore #${a.giocatoreId}'),
                          subtitle: Text(g?.squadra ?? ''),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('${a.prezzo.toStringAsFixed(0)} cr'),
                              IconButton(
                                icon: const Icon(Icons.close, size: 18),
                                onPressed: () => astaProvider
                                    .rimuoviAcquisto(a.giocatoreId),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _confermaReset(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reimpostare l\'asta?'),
        content: const Text(
          'Verranno cancellati budget, configurazione e tutti i giocatori acquistati.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annulla'),
          ),
          TextButton(
            onPressed: () {
              context.read<AstaProvider>().reset();
              Navigator.pop(ctx);
            },
            child: const Text('Reimposta'),
          ),
        ],
      ),
    );
  }
}

class _HeaderBudget extends StatelessWidget {
  final AstaProvider astaProvider;
  const _HeaderBudget({required this.astaProvider});

  @override
  Widget build(BuildContext context) {
    final rimanente = astaProvider.budgetRimanente;
    final colore = rimanente < 0 ? Colors.red : Colors.green.shade800;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _statBudget('Totale', astaProvider.config!.budgetTotale),
          _statBudget('Speso', astaProvider.budgetSpeso),
          _statBudget('Rimanente', rimanente, colore: colore),
        ],
      ),
    );
  }

  Widget _statBudget(String label, double valore, {Color? colore}) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12)),
        Text(
          valore.toStringAsFixed(0),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: colore,
          ),
        ),
      ],
    );
  }
}