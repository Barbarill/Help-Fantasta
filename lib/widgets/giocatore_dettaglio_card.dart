import 'package:flutter/material.dart';
import '../models/giocatore.dart';
import 'ruolo_badge.dart';

class GiocatoreDettaglioCard extends StatelessWidget {
  final Giocatore g;
  final double? punteggio;
  final bool evidenziaMigliore;

  const GiocatoreDettaglioCard({
    super.key,
    required this.g,
    this.punteggio,
    this.evidenziaMigliore = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: evidenziaMigliore
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Colors.amber, width: 2),
            )
          : null,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                RuoloBadge(ruolo: g.ruolo),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(g.nome,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(g.squadra,
                          style: TextStyle(color: Colors.grey.shade700)),
                    ],
                  ),
                ),
                if (evidenziaMigliore)
                  const Icon(Icons.emoji_events, color: Colors.amber),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (g.ruolo == Ruolo.attaccante && g.rigoriCalciati != null && g.rigoriCalciati! > 0)
                  _badge('Rigorista', Colors.deepPurple),
                if (g.ruoloMantra != null)
                  _badge('Mantra: ${g.ruoloMantra}', Colors.blueGrey),
              ],
            ),
            const SizedBox(height: 12),
            _riga('Fantamedia', g.fantamedia?.toStringAsFixed(2)),
            _riga('Media voto', g.mediaVoto?.toStringAsFixed(2)),
            _riga('Presenze', g.presenze?.toString()),
            const Divider(),
            _riga('Gol fatti', g.golFatti?.toString()),
            _riga('Assist', g.assist?.toString()),
            if (g.ruolo == Ruolo.portiere)
              _riga('Gol subiti', g.golSubiti?.toString()),
            _riga('Rigori calciati', g.rigoriCalciati?.toString()),
            _riga('Rigori segnati', g.rigoriSegnati?.toString()),
            if (g.ruolo == Ruolo.portiere)
              _riga('Rigori parati', g.rigoriParati?.toString()),
            const Divider(),
            _riga('Ammonizioni', g.ammonizioni?.toString()),
            _riga('Espulsioni', g.espulsioni?.toString()),
            _riga('Autogol', g.autogol?.toString()),
            if (punteggio != null) ...[
              const Divider(),
              _riga('Punteggio complessivo', punteggio!.toStringAsFixed(1),
                  evidenzia: true),
            ],
          ],
        ),
      ),
    );
  }

  Widget _badge(String testo, Color colore) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: colore.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(testo,
          style: TextStyle(
              color: colore, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }

  Widget _riga(String label, String? valore, {bool evidenzia = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade700)),
          Text(
            valore ?? 'N/D',
            style: TextStyle(
              fontWeight: evidenzia ? FontWeight.bold : FontWeight.normal,
              fontSize: evidenzia ? 16 : 14,
              color: evidenzia ? Colors.green.shade800 : null,
            ),
          ),
        ],
      ),
    );
  }
}