import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/giocatore.dart';
import '../providers/giocatori_provider.dart';
import '../providers/pesi_provider.dart';
import '../services/punteggio_service.dart';
import '../widgets/giocatore_dettaglio_card.dart';

class ConfrontaScreen extends StatefulWidget {
  const ConfrontaScreen({super.key});

  @override
  State<ConfrontaScreen> createState() => _ConfrontaScreenState();
}

class _ConfrontaScreenState extends State<ConfrontaScreen> {
  bool _modalitaMultipla = false;
  final List<Giocatore> _selezionati = [];
  final PunteggioService _punteggioService = PunteggioService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confronta'),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune),
            tooltip: 'Regola i pesi del punteggio',
            onPressed: () => _apriPesi(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: false, label: Text('Scheda singola')),
                ButtonSegment(value: true, label: Text('Confronto multiplo')),
              ],
              selected: {_modalitaMultipla},
              onSelectionChanged: (s) => setState(() {
                _modalitaMultipla = s.first;
                _selezionati.clear();
              }),
            ),
          ),
          _CercaAggiungi(
            giaSelezionati: _selezionati,
            multiplo: _modalitaMultipla,
            onSelezionato: (g) => setState(() {
              if (!_modalitaMultipla) {
                _selezionati
                  ..clear()
                  ..add(g);
              } else {
                if (_selezionati.isEmpty || _selezionati.first.ruolo == g.ruolo) {
                  _selezionati.add(g);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Puoi confrontare solo giocatori dello stesso ruolo'),
                    ),
                  );
                }
              }
            }),
          ),
          Expanded(
            child: _selezionati.isEmpty
                ? const Center(child: Text('Cerca un giocatore per iniziare'))
                : _modalitaMultipla
                    ? _confrontoMultiplo()
                    : _schedaSingola(),
          ),
        ],
      ),
    );
  }

  Widget _schedaSingola() {
    final pesi = context.watch<PesiProvider>().pesi;
    final g = _selezionati.first;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: GiocatoreDettaglioCard(
        g: g,
        punteggio: _punteggioService.calcola(g, pesi),
      ),
    );
  }

  Widget _confrontoMultiplo() {
    final pesi = context.watch<PesiProvider>().pesi;
    final ordinati = _punteggioService.ordina(_selezionati, pesi);
    final migliore = ordinati.first;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Column(
        children: ordinati.map((g) {
          return Stack(
            children: [
              GiocatoreDettaglioCard(
                g: g,
                punteggio: _punteggioService.calcola(g, pesi),
                evidenziaMigliore: g.id == migliore.id,
              ),
              Positioned(
                top: 4,
                right: 12,
                child: IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: () => setState(() => _selezionati.remove(g)),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  void _apriPesi(BuildContext context) {
    final pesiProvider = context.read<PesiProvider>();
    var pesi = pesiProvider.pesi;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: SizedBox(
            height: MediaQuery.of(ctx).size.height * 0.7,
            child: ListView(
              children: [
                Text('Pesi del punteggio',
                    style: Theme.of(ctx).textTheme.titleLarge),
                const Text(
                  'Regola quanto conta ogni statistica nel calcolo. '
                  'Valori più alti = più peso nella decisione finale.',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 12),
                _sliderPeso('Fantamedia', pesi.fantamedia, 0, 20,
                    (v) => setModalState(() => pesi = pesi.copyWith(fantamedia: v))),
                _sliderPeso('Gol', pesi.gol, 0, 10,
                    (v) => setModalState(() => pesi = pesi.copyWith(gol: v))),
                _sliderPeso('Assist', pesi.assist, 0, 10,
                    (v) => setModalState(() => pesi = pesi.copyWith(assist: v))),
                _sliderPeso('Rigori segnati', pesi.rigoriSegnati, 0, 10,
                    (v) => setModalState(() => pesi = pesi.copyWith(rigoriSegnati: v))),
                _sliderPeso('Ammonizioni (malus)', pesi.ammonizioni, 0, 5,
                    (v) => setModalState(() => pesi = pesi.copyWith(ammonizioni: v))),
                _sliderPeso('Espulsioni (malus)', pesi.espulsioni, 0, 10,
                    (v) => setModalState(() => pesi = pesi.copyWith(espulsioni: v))),
                _sliderPeso('Autogol (malus)', pesi.autogol, 0, 10,
                    (v) => setModalState(() => pesi = pesi.copyWith(autogol: v))),
                _sliderPeso('Rigori parati (portieri)', pesi.rigoriParati, 0, 10,
                    (v) => setModalState(() => pesi = pesi.copyWith(rigoriParati: v))),
                _sliderPeso('Gol subiti a partita (malus portieri)',
                    pesi.golSubitiAPartita, 0, 15,
                    (v) => setModalState(() => pesi = pesi.copyWith(golSubitiAPartita: v))),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setModalState(() => pesi = const PesiPunteggio());
                        },
                        child: const Text('Reimposta default'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          pesiProvider.aggiorna(pesi);
                          Navigator.pop(ctx);
                        },
                        child: const Text('Applica'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sliderPeso(
      String label, double valore, double min, double max, ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: ${valore.toStringAsFixed(1)}'),
        Slider(
          value: valore,
          min: min,
          max: max,
          divisions: ((max - min) * 2).toInt(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _CercaAggiungi extends StatefulWidget {
  final List<Giocatore> giaSelezionati;
  final bool multiplo;
  final ValueChanged<Giocatore> onSelezionato;

  const _CercaAggiungi({
    required this.giaSelezionati,
    required this.multiplo,
    required this.onSelezionato,
  });

  @override
  State<_CercaAggiungi> createState() => _CercaAggiungiState();
}

class _CercaAggiungiState extends State<_CercaAggiungi> {
  final _controller = TextEditingController();
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final giocatoriProvider = context.watch<GiocatoriProvider>();
    final risultati = _query.trim().isEmpty
        ? <Giocatore>[]
        : giocatoriProvider.giocatori
            .where((g) => !widget.giaSelezionati.any((s) => s.id == g.id))
            .where((g) => g.nome.toLowerCase().contains(_query.toLowerCase()))
            .take(10)
            .toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: widget.multiplo
                  ? 'Aggiungi un altro giocatore da confrontare'
                  : 'Cerca un giocatore',
              border: const OutlineInputBorder(),
            ),
            onChanged: (v) => setState(() => _query = v),
          ),
        ),
        if (risultati.isNotEmpty)
          SizedBox(
            height: 180,
            child: ListView.builder(
              itemCount: risultati.length,
              itemBuilder: (context, index) {
                final g = risultati[index];
                return ListTile(
                  dense: true,
                  title: Text(g.nome),
                  subtitle: Text('${g.ruolo.sigla} • ${g.squadra}'),
                  onTap: () {
                    widget.onSelezionato(g);
                    setState(() {
                      _controller.clear();
                      _query = '';
                    });
                    FocusScope.of(context).unfocus();
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}