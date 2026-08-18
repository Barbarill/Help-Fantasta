import 'package:flutter/material.dart';
import '../models/giocatore.dart';
import '../theme/app_theme.dart';

Color coloreRuolo(Ruolo ruolo) {
  switch (ruolo) {
    case Ruolo.portiere:
      return AppColors.portiere;
    case Ruolo.difensore:
      return AppColors.difensore;
    case Ruolo.centrocampista:
      return AppColors.centrocampista;
    case Ruolo.attaccante:
      return AppColors.attaccante;
  }
}

class RuoloBadge extends StatelessWidget {
  final Ruolo ruolo;
  const RuoloBadge({super.key, required this.ruolo});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: coloreRuolo(ruolo),
        shape: BoxShape.circle,
      ),
      child: Text(
        ruolo.sigla,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}