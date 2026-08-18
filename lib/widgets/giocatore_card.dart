import 'package:flutter/material.dart';
import '../models/giocatore.dart';
import 'ruolo_badge.dart';

class GiocatoreCard extends StatelessWidget {
  final Giocatore giocatore;
  final Widget? trailing;
  final String? sottotitoloExtra;
  final VoidCallback? onTap;

  const GiocatoreCard({
    super.key,
    required this.giocatore,
    this.trailing,
    this.sottotitoloExtra,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final fm = giocatore.fantamedia;
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: RuoloBadge(ruolo: giocatore.ruolo),
        title: Text(
          giocatore.nome,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          sottotitoloExtra ??
              '${giocatore.squadra}'
                  '${fm != null ? " • Fantamedia ${fm.toStringAsFixed(2)}" : ""}',
        ),
        trailing: trailing,
      ),
    );
  }
}