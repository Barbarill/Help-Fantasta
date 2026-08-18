import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/giocatore.dart';
import '../providers/asta_provider.dart';
import '../providers/giocatori_provider.dart';

Future<void> mostraRicercaGiocatore(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (_) => const _RicercaGiocatoreSheet(),
  );
}

class _RicercaGiocatoreSheet extends StatefulWidget {
  const _RicercaGiocatoreSheet();

  @override
  State<_RicercaGiocatoreSheet> createState() =>
      _RicercaGiocatoreSheetState();
}

class _RicercaGiocatoreSheetState extends State<_RicercaGiocatoreSheet> {
  String _query = '';
  Giocatore? _selezionato;
  final _prezzoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final giocatoriProvider = context.watch<GiocatoriProvider>();
    final astaProvider = context.watch<AstaProvider>();

    final risultati = _query.trim().isEmpty
        ? <Giocatore>[]
        : giocatoriProvider.giocatori
            .where((g) => !astaProvider.giaAcquistato(g.id))
            .where((g) => g.nome.toLowerCase().contains(_query.toLowerCase()))
            .take(20)
            .toList();

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Assegna giocatore',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            if (_selezionato == null) ...[
              TextField(
                autofocus: true,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Cerca per nome',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => setState(() => _query = value),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: risultati.length,
                  itemBuilder: (context, index) {
                    final g = risultati[index];
                    final slotPieno = astaProvider.slotLiberi(g.ruolo) <= 0;
                    return ListTile(
                      enabled: !slotPieno,
                      title: Text(g.nome),
                      subtitle: Text(
                        slotPieno
                            ? '${g.ruolo.sigla} • ${g.squadra} • Slot ${g.ruolo.nomeCompleto.toLowerCase()} pieni'
                            : '${g.ruolo.sigla} • ${g.squadra}'
                                '${g.quotazione != null ? " • Quot. ${g.quotazione!.toStringAsFixed(0)}" : ""}',
                        style: slotPieno
                            ? TextStyle(color: Theme.of(context).disabledColor)
                            : null,
                      ),
                      onTap: slotPieno
                          ? null
                          : () => setState(() => _selezionato = g),
                    );
                  },
                ),
              ),
            ] else ...[
              Card(
                child: ListTile(
                  title: Text(_selezionato!.nome),
                  subtitle: Text(
                    '${_selezionato!.ruolo.nomeCompleto} • ${_selezionato!.squadra}'
                    '${_selezionato!.fantamedia != null ? " • Fantamedia ${_selezionato!.fantamedia!.toStringAsFixed(2)}" : ""}',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => setState(() => _selezionato = null),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _prezzoController,
                autofocus: true,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Crediti spesi',
                  border: const OutlineInputBorder(),
                  suffixText:
                      'Rimanenti: ${astaProvider.budgetRimanente.toStringAsFixed(0)}',
                ),
                onChanged: (_) => setState(() {}),
              ),
              if ((double.tryParse(_prezzoController.text) ?? 0) >
                  astaProvider.budgetRimanente)
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    'Budget insufficiente per questo acquisto',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _conferma(context, astaProvider),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text('Conferma acquisto'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _conferma(BuildContext context, AstaProvider astaProvider) {
    final prezzo = double.tryParse(_prezzoController.text);
    if (prezzo == null || prezzo < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Inserisci un prezzo valido')),
      );
      return;
    }
    if (prezzo > astaProvider.budgetRimanente) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Budget insufficiente')),
      );
      return;
    }
    astaProvider.aggiungiAcquisto(_selezionato!, prezzo);
    Navigator.pop(context);
  }
}